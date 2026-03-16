import SwiftUI

#if canImport(UIKit)
  import UIKit
#elseif canImport(AppKit)
  import AppKit
#endif
import CoreText

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

      guard let url = Bundle.designSystemBundle.url(forResource: path, withExtension: nil) else { return }

      #if canImport(UIKit)
        guard !PlatformFont.fontNames(forFamilyName: T.name).contains(name) else { return }
      #endif

      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
  }

  public func register() {
    FontFamily.allCases.forEach { fontFamily in
      register(fontFamily.type)
    }
  }
}
