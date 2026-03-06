//
//  HapticFeedback.swift
//  Core
//
//  Created by YoungK on 3/6/26.
//

import UIKit

public enum HapticFeedback {
  public static func generate(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
  }

  public static func generate(success: Bool) {
    let generator = UINotificationFeedbackGenerator()
    success
    ? generator.notificationOccurred(.success)
    : generator.notificationOccurred(.error)
  }
}
