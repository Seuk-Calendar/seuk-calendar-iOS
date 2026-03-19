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

      var registrationError: Unmanaged<CFError>?
      let isRegistered = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &registrationError)

      guard !isRegistered else { return }

      let errorDescription = registrationError
        .map { CFErrorCopyDescription($0.takeRetainedValue()) as String? ?? "unknown error" }
        ?? "unknown error"
      print("🔴 Font registration failed: \(name) (\(url.path)) - \(errorDescription)")
    }
  }

  public func register() {
    FontFamily.allCases.forEach { fontFamily in
      register(fontFamily.type)
    }
  }
}
