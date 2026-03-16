import AVFoundation
import Photos

#if canImport(UIKit)
  import UIKit
#endif

public struct SystemPermissionHelper: SystemPermissionHelperInterface {
  private enum Status {
    case notDetermined
    case authorized
    case limited
    case nonAuthorized

    var isAuthorized: Bool {
      self == .authorized
    }
  }

  private let avCaptureDeviceAuthorization: AVCaptureDeviceAuthorizationProtocol.Type
  private let phPhotoLibraryAuthorization: PHPhotoLibraryAuthorizationProtocol.Type

  public init(
    avCaptureDeviceAuthorization: AVCaptureDeviceAuthorizationProtocol.Type,
    phPhotoLibraryAuthorization: PHPhotoLibraryAuthorizationProtocol.Type
  ) {
    self.avCaptureDeviceAuthorization = avCaptureDeviceAuthorization
    self.phPhotoLibraryAuthorization = phPhotoLibraryAuthorization
  }

  public func requestPermission(target: SystemPermissionTarget) async -> SystemPermissionResultBehavior {
    let status = getStatus(target: target)
    return await _requestPermission(target: target, status: status)
  }
}

extension SystemPermissionHelper {
  /// 권한 상태 얻기
  /// - Parameter target: 어떤 시스템 권한을 원하는 지
  /// - Returns: 해당 시스템 권한
  private func getStatus(target: SystemPermissionTarget) -> SystemPermissionHelper.Status {
    let status: SystemPermissionHelper.Status

    switch target {
    case .photo:
      switch phPhotoLibraryAuthorization.authorizationStatus(for: .readWrite) {
      case .notDetermined:
        status = .notDetermined
      case .authorized:
        status = .authorized
      case .limited:
        status = .limited
      default:
        status = .nonAuthorized
      }
    case .camera:
      switch avCaptureDeviceAuthorization.authorizationStatus(for: .video) {
      case .authorized:
        status = .authorized
      case .notDetermined:
        status = .notDetermined
      default:
        status = .nonAuthorized
      }
    }

    return status
  }

  @MainActor
  private func openMoveToSettingPopup(
    target: SystemPermissionTarget,
    behavior: SystemPermissionResultBehavior
  ) async -> SystemPermissionResultBehavior {
    #if canImport(UIKit)
      await withCheckedContinuation { continuation in
        let alertController = UIAlertController(
          title: target.title,
          message: target.message,
          preferredStyle: .alert
        )

        alertController.addAction(.init(title: String(localized: "Settings"), style: .default) { _ in
          if let settingURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingURL)
            continuation.resume(returning: behavior)
          }
        })

        alertController.addAction(.init(title: String(localized: "cancel"), style: .cancel) { _ in
          continuation.resume(returning: behavior)
        })

        UIApplication.shared.rootViewController?.present(alertController, animated: true)
      }
    #else
      _ = target
      return behavior
    #endif
  }

  private func requestSystemAuthorization(
    target: SystemPermissionTarget
  ) async -> SystemPermissionResultBehavior {
    switch target {
    case .photo:
      let status = await phPhotoLibraryAuthorization.requestAuthorization(for: .readWrite)
      switch status {
      case .authorized:
        return .authorized
      case .notDetermined, .denied, .restricted:
        return .denied
      default:
        switch status.rawValue {
        case 4:
          return .limited
        default:
          return .denied
        }
      }
    case .camera:
      let granted = await avCaptureDeviceAuthorization.requestAccess(for: .video)
      return granted ? .authorized : .denied
    }
  }

  @MainActor
  private func _requestPermission(
    target: SystemPermissionTarget,
    status: Status
  ) async -> SystemPermissionResultBehavior {
    switch status {
    case .authorized:
      return .authorized
    case .limited:
      return await openMoveToSettingPopup(target: target, behavior: .limited)
    case .nonAuthorized:
      return await openMoveToSettingPopup(target: target, behavior: .denied)
    case .notDetermined:
      return await requestSystemAuthorization(target: target)
    }
  }
}

fileprivate extension SystemPermissionTarget {
  var title: String {
    switch self {
    case .photo:
      return String(localized: "원활한 이용을 위해 전체 접근이 필요합니다.")
    case .camera:
      return String(localized: "No permission to access camera")
    }
  }

  var message: String {
    String(localized: "설정 앱에서 권한을 변경해주세요.")
  }
}
