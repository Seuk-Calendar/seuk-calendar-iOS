import _PhotosUI_SwiftUI
import Photos
import PhotosUI

public final class ImageTransformer: PhotosPickerImagesRepresentable, PhotoPickerPHAssetRepresentable {
  private let manager = PHImageManager.default()

  /// 병렬 개수 제한 (메모리 보호용)
  private let maxConcurrentTasks = 4

  public init() {}

  public func transform(_ items: [PhotosPickerItem]) async throws -> [PlatformImage] {
    let assets = await getPHAssets(from: items)

    var results: [PlatformImage?] = .init(repeating: nil, count: assets.count)

    try await withThrowingTaskGroup(of: (Int, PlatformImage).self) { group in
      var iterator = assets.enumerated().makeIterator()

      // 초기 작업 투입
      for _ in 0 ..< min(maxConcurrentTasks, assets.count) {
        if let (index, asset) = iterator.next() {
          group.addTask {
            let image = try await self.requestHighQualityImage(from: asset)
            return (index, image)
          }
        }
      }

      // 작업 완료될 때마다 새 작업 추가
      while let (index, image) = try await group.next() {
        results[index] = image

        if let (nextIndex, nextAsset) = iterator.next() {
          group.addTask {
            let image = try await self.requestHighQualityImage(from: nextAsset)
            return (nextIndex, image)
          }
        }
      }
    }

    return results.compactMap { $0 }
  }
}

private extension ImageTransformer {
  func requestHighQualityImage(from asset: PHAsset) async throws -> PlatformImage {
    try await withCheckedThrowingContinuation { continuation in
      let options = PHImageRequestOptions()
      options.deliveryMode = .highQualityFormat
      options.isNetworkAccessAllowed = true
      options.isSynchronous = false
      options.resizeMode = .none

      manager.requestImage(
        for: asset,
        targetSize: PHImageManagerMaximumSize, // 업로드용 → 원본
        contentMode: .aspectFit,
        options: options
      ) { image, info in
        // 에러 체크
        if let error = info?[PHImageErrorKey] as? Error {
          continuation.resume(throwing: error)
          return
        }

        // 취소 체크
        if let cancelled = info?[PHImageCancelledKey] as? Bool, cancelled {
          continuation.resume(throwing: PhotosPickerItemTransformerError.failedToLoadData)
          return
        }

        // 🔥 degraded 이미지 무시
        let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
        if isDegraded { return }

        guard let image else {
          continuation.resume(throwing: PhotosPickerItemTransformerError.failedToLoadData)
          return
        }

        continuation.resume(returning: image)
      }
    }
  }
}
