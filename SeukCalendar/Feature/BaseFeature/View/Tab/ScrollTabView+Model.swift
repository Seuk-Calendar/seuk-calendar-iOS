import SwiftUI

public extension ScrollableTabView {
  struct TabModel: Identifiable {
    public var id: String // title 역할
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    var layout: Layout = .normal

    public init(title: String, layout: Layout = .normal) {
      self.id = title
      self.layout = layout
    }
  }
}

public extension ScrollableTabView.TabModel {
  enum Layout {
    case normal
    case overlay
  }
}
