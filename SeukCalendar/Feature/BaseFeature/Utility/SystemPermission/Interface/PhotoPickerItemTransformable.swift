import _PhotosUI_SwiftUI
import Core
import Foundation

#if canImport(UIKit)
  import UIKit

  public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
  import AppKit

  public typealias PlatformImage = NSImage
#endif

enum PhotosPickerItemTransformerError: SCError {
  case failedToLoadData
  case missingSelf

  var errorDescription: String {
    switch self {
    case .failedToLoadData:
      "로드 실패"
    case .missingSelf:
      "Self 캡쳐 싪패"
    }
  }

  var userMessage: String {
    return "미디어 데이터를 갖고오지 못했습니다."
  }
}

public protocol PhotosPickerImagesRepresentable {
  func transform(_ items: [PhotosPickerItem]) async throws -> [PlatformImage]
}

public protocol PhotoPickerPHAssetRepresentable {}

public extension PhotoPickerPHAssetRepresentable {
  func getPHAsset(from item: PhotosPickerItem) async throws -> PHAsset {
    guard let identifier = item.itemIdentifier
    else {
      throw PhotosPickerItemTransformerError.failedToLoadData
    }

    let result = PHAsset.fetchAssets(
      withLocalIdentifiers: [identifier],
      options: nil
    )

    guard let asset = result.firstObject else {
      throw PhotosPickerItemTransformerError.failedToLoadData
    }

    return asset
  }

  func getPHAssets(from items: [PhotosPickerItem]) async -> [PHAsset] {
    let result = PHAsset.fetchAssets(
      withLocalIdentifiers: items.compactMap { $0.itemIdentifier },
      options: nil
    )

    if result.count == .zero {
      return []
    }

    return result.objects(at: IndexSet(integersIn: 0 ..< result.count))
  }
}

public protocol PhotosPickerAssetRepresentable {
  func transform(_ item: PhotosPickerItem) async throws -> AVAsset
}
