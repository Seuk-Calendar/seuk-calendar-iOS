//
//  HapticFeedback.swift
//  Core
//
//  Created by YoungK on 3/6/26.
//

#if canImport(UIKit)
  import UIKit
#endif

public enum HapticFeedback {
  #if canImport(UIKit)
    public static func generate(style: UIImpactFeedbackGenerator.FeedbackStyle) {
      let generator = UIImpactFeedbackGenerator(style: style)
      generator.impactOccurred()
    }
  #endif

  #if canImport(UIKit)
    public static func generate(success: Bool) {
      let generator = UINotificationFeedbackGenerator()
      success
        ? generator.notificationOccurred(.success)
        : generator.notificationOccurred(.error)
    }
  #endif
}
