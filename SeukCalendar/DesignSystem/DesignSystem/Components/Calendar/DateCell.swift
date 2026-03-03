import SwiftUI

public struct DateCell: View {
  public let dayText: String
  public let isSelected: Bool
  public let isToday: Bool
  public let isInCurrentMonth: Bool
  public let eventCount: Int
  public var action: (() -> Void)?

  public init(
    dayText: String,
    isSelected: Bool,
    isToday: Bool,
    isInCurrentMonth: Bool,
    eventCount: Int,
    action: (() -> Void)? = nil
  ) {
    self.dayText = dayText
    self.isSelected = isSelected
    self.isToday = isToday
    self.isInCurrentMonth = isInCurrentMonth
    self.eventCount = eventCount
    self.action = action
  }

  public var body: some View {
    Button(action: { action?() }) {
      VStack(spacing: 6) {
        Text(dayText)
          .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
          .foregroundStyle(foregroundColor)
          .frame(maxWidth: .infinity)
          .padding(.top, 6)

        HStack(spacing: 3) {
          ForEach(0..<dotCount, id: \.self) { _ in
            Circle()
              .fill(isSelected ? Color.white.opacity(0.9) : .blue)
              .frame(width: 4, height: 4)
          }
        }
        .frame(height: 6)
        .padding(.bottom, 6)
      }
      .frame(maxWidth: .infinity)
      .frame(height: 48)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    .buttonStyle(.plain)
  }
}

private extension DateCell {
  var dotCount: Int {
    min(max(eventCount, 0), 3)
  }

  var backgroundColor: Color {
    if isSelected {
      return .blue
    }

    if isToday {
      return .blue.opacity(0.12)
    }

    return .clear
  }

  var foregroundColor: Color {
    if isSelected {
      return .white
    }

    if !isInCurrentMonth {
      return .secondary.opacity(0.6)
    }

    return .primary
  }
}
