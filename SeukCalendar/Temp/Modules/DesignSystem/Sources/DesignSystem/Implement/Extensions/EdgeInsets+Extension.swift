//
//  EdgeInsets+Extension.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 10/20/25.
//

import SwiftUI

public extension EdgeInsets {
  init(
    vertical: CGFloat = .zero,
    horizontal: CGFloat = .zero
  ) {
    self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
  }
}
