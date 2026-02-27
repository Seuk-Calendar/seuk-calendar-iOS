//
//  Configuration.swift
//  Pool
//
//  Created by yongbeomkwak on 7/12/25.
//

import Foundation
import SwiftUI

public extension RoundedBorder {
  struct Configuration {
    public let cornerSize: CGSize
    public let borderColor: Color
    public let borderWidth: CGFloat

    public init(
      cornerSize: CGSize,
      borderColor: Color,
      borderWidth: CGFloat
    ) {
      self.cornerSize = cornerSize
      self.borderColor = borderColor
      self.borderWidth = borderWidth
    }
  }
}
