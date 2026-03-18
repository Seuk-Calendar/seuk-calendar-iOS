import SwiftUI

#if canImport(UIKit)
  import UIKit
#elseif canImport(AppKit)
  import AppKit
#endif
import CoreText

public struct FontManager {
  private static let lock = NSLock()
  private static var didRegisterFonts = false

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
        guard UIFont(name: name, size: 12) == nil else { return }
      #elseif canImport(AppKit)
        guard NSFont(name: name, size: 12) == nil else { return }
      #endif

      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
  }

  public func register() {
    Self.lock.lock()
    defer { Self.lock.unlock() }

    guard Self.didRegisterFonts == false else { return }

    FontFamily.allCases.forEach { fontFamily in
      register(fontFamily.type)
    }

    Self.didRegisterFonts = true
  }
}
