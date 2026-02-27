//
//  FontConvertible.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 7/14/25.
//

import SwiftUI
import UIKit.UIFont

public struct FontManager {
  public enum FontFamily: CaseIterable {
    case pretendard

    var type: any FontFamilyType {
      switch self {
      case .pretendard:
        return Pretendard()
      }
    }
  }

  public static let shared = FontManager()

  private init () {}

  private func register<T: FontFamilyType>(_ font: T) where T.Weight: RawRepresentable, T.Weight.RawValue == String {
    T.Weight.allCases.map(\.rawValue).forEach {
      let name = "\(T.name)-\($0)"
      let path = "\(name)\(font.extension.rawValue)"

      if !UIFont.fontNames(forFamilyName: T.name).contains(name) {
        guard let url = Bundle.module.url(forResource: path, withExtension: nil) else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
      }
    }
  }

  public func register() {
    FontFamily.allCases.forEach { fontFamily in
      register(fontFamily.type)
    }
  }
}
