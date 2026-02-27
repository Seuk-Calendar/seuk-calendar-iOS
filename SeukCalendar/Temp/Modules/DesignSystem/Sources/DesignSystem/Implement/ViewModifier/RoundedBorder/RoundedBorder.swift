//
//  RoundRectangle.swift
//  Pool
//
//  Created by yongbeomkwak on 7/5/25.
//

import SwiftUI

public struct RoundedBorder: ViewModifier {
  private let configuration: RoundedBorder.Configuration

  init(configuration: RoundedBorder.Configuration) {
    self.configuration = configuration
  }

  public func body(content: Content) -> some View {
    content
      .clipShape(.rect(cornerSize: configuration.cornerSize))
      .overlay {
        RoundedRectangle(cornerSize: configuration.cornerSize)
          .stroke(
            configuration.borderColor,
            lineWidth: configuration.borderWidth
          )
      }
  }
}

public extension View {
  func roundedBorder(
    cornerRadius: CGFloat,
    borderColor: Color,
    borderWidth: CGFloat = 1.0
  ) -> some View {
    self.modifier(
      RoundedBorder(
        configuration: RoundedBorder.Configuration(
          cornerSize: CGSize(width: cornerRadius, height: cornerRadius),
          borderColor: borderColor,
          borderWidth: borderWidth
        )
      )
    )
  }
}

private struct RoundedBorderPreview: View {
  var body: some View {
    HStack {
      Text("Hello")
        .background(Color.blue)
        .roundedBorder(cornerRadius: 2, borderColor: .red)
    }
  }
}

#Preview {
  RoundedBorderPreview()
}
