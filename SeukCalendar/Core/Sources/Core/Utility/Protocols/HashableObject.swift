//
//  HashableObject.swift
//  Core
//
//  Created by yongbeomkwak on 10/7/25.
//

import Foundation

public protocol HashableObject: AnyObject, Hashable, Identifiable {}

public extension HashableObject {
  nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
    lhs === rhs
  }

  nonisolated func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}
