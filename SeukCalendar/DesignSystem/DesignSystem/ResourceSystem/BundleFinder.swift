import Foundation

final class BundleFinder {}

extension Foundation.Bundle {
  static let designSystemBundle = Bundle(for: BundleFinder.self)
}
