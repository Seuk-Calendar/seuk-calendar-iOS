//
//  Comparable.swift
//  Core
//
//  Created by yongbeomkwak on 2/8/26.
//

import Foundation

public extension Comparable {
  func clamped(to range: ClosedRange<Self>) -> Self {
    min(max(self, range.lowerBound), range.upperBound)
  }
}
