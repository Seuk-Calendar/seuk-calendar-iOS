//
//  Color+Init.swift
//  DesignSystem
//
//  Created by YoungK on 10/9/25.
//

import SwiftUI

extension Color {
  init(_ colorFamily: PoolColor.ColorFamily, name: String) {
    self.init("\(colorFamily.rawValue)/\(name)", bundle: .designSystemBundle)
  }
}
