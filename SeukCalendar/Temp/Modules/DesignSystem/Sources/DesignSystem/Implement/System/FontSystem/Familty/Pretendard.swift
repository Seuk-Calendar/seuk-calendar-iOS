//
//  Pretendard.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 7/14/25.
//

import Foundation

public struct Pretendard: FontFamilyType {
  public enum Weight: String, CaseIterable {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case extraLight = "ExtraLight"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    case thin = "Thin"
  }

  public let `extension`: FontFileExtension = .otf
  public static let name: String = String(describing: Pretendard.self)
}
