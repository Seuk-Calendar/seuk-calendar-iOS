import SwiftUI

public struct MoreWrapComponent: View {
  private let configuration: Configuration

  public init(configuration: Configuration) {
    self.configuration = configuration
  }

  @ViewBuilder
  public var body: some View {
    if let displayText = configuration.displayText {
      Text(displayText)
        .font(.homeCalendar(weight: .semiBold, size: 9))
        .foregroundStyle(Color.primitives.gray800)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .frame(maxWidth: .infinity, alignment: .center)
    }
  }
}

#if DEBUG
  #Preview {
    VStack(spacing: Spacing.sp200) {
      MoreWrapComponent(configuration: .init(count: 2))
      MoreWrapComponent(configuration: .init(text: "+4개의 일정 더"))
    }
    .padding()
  }
#endif
