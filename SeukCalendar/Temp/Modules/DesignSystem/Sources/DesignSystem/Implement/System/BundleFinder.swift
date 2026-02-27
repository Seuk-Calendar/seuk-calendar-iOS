//
//  BundleFinder.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 7/14/25.
//

import Foundation

private final class BundleFinder {}

extension Foundation.Bundle {
  static let designSystemBundle = Bundle(for: BundleFinder.self)
}
