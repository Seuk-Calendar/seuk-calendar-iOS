import Foundation

public protocol SystemPermissionHelperInterface {
  func requestPermission(
    target: SystemPermissionTarget
  ) async -> SystemPermissionResultBehavior
}
