import SwiftUI
import UIKit

public struct BlurView: UIViewRepresentable {
  let style: UIBlurEffect.Style
  
  public init(style: UIBlurEffect.Style) {
    self.style = style
  }
  
  public func makeUIView(context: Context) -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: style)
    let blurView = UIVisualEffectView(effect: blurEffect)
    return blurView
  }

  public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
