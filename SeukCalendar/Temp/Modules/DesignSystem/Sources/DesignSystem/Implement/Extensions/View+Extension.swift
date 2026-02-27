//
//  View+Extension.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 10/20/25.
//

import SwiftUI

public extension View {
  func frame(_ length: CGFloat, alignment: Alignment = .center) -> some View {
    self.frame(width: length, height: length, alignment: alignment)
  }
}
