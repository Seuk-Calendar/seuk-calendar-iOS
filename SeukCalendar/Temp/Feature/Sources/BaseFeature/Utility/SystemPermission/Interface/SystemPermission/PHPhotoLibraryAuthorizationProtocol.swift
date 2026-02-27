import Photos

public protocol PHPhotoLibraryAuthorizationProtocol {
  static func authorizationStatus(for accessLevel: PHAccessLevel) -> PHAuthorizationStatus
  static func requestAuthorization(for accessLevel: PHAccessLevel) async -> PHAuthorizationStatus
}

extension PHPhotoLibrary: PHPhotoLibraryAuthorizationProtocol {}
