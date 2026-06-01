import DesignSystem
import SwiftUI

struct SelectedDateDetailPanel: View {
  let selectedDate: Date
  let events: [CalendarEvent]
  let height: CGFloat
  let panelAccessibilityValue: String
  let onHandleDragChanged: (CGFloat) -> Void
  let onHandleDragEnded: (CGFloat) -> Void
  let onExpand: () -> Void
  let onCollapse: () -> Void
  let onTapAIAdd: () -> Void
  let onTapEvent: (CalendarEvent) -> Void
  let onRequestDelete: (CalendarEvent) -> Void

  var body: some View {
    VStack(spacing: 0) {
      handleBar

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 18) {
          header
          aiAddButton
          eventSection
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
      }
    }
    .frame(maxWidth: .infinity)
    .frame(height: height, alignment: .top)
    .background(Color.primitives.white)
    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: -6)
    .accessibilityElement(children: .contain)
  }
}

private extension SelectedDateDetailPanel {
  var handleBar: some View {
    VStack(spacing: 12) {
      Capsule(style: .continuous)
        .fill(Color.primitives.gray300)
        .frame(width: 54, height: 6)
        .padding(.top, 12)
        .accessibilityHidden(true)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 36)
    .contentShape(Rectangle())
    .gesture(
      DragGesture(minimumDistance: 4)
        .onChanged { value in
          onHandleDragChanged(value.translation.height)
        }
        .onEnded { value in
          onHandleDragEnded(value.predictedEndTranslation.height)
        }
    )
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("일정 상세 패널 크기")
    .accessibilityValue(panelAccessibilityValue)
    .accessibilityHint("위아래로 드래그해 패널 크기를 조절합니다.")
    .accessibilityAdjustableAction { direction in
      switch direction {
      case .increment:
        onExpand()
      case .decrement:
        onCollapse()
      @unknown default:
        break
      }
    }
  }

  var header: some View {
    HStack(alignment: .firstTextBaseline, spacing: 10) {
      Text(selectedDateTitle)
        .font(.system(size: 28, weight: .bold))
        .foregroundStyle(Color.primitives.black)

      Spacer(minLength: 0)

      Text("\(events.count)개 일정")
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(Color.primitives.gray600)
    }
  }

  var aiAddButton: some View {
    Button(action: onTapAIAdd) {
      HStack(spacing: 10) {
        Image(systemName: "sparkles")
          .font(.system(size: 15, weight: .semibold))

        Text("AI 일정 추가")
          .font(.system(size: 15, weight: .semibold))

        Spacer(minLength: 0)

        Image(systemName: "chevron.right")
          .font(.system(size: 13, weight: .semibold))
      }
      .foregroundStyle(Color.primitives.white)
      .padding(.horizontal, 16)
      .padding(.vertical, 13)
      .background(
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .fill(Color.primitives.blue600)
      )
    }
    .buttonStyle(.plain)
  }

  @ViewBuilder
  var eventSection: some View {
    if events.isEmpty {
      HStack(alignment: .center, spacing: 12) {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
          .fill(Color.primitives.gray300)
          .frame(width: 5, height: 38)

        Text("일정이 없습니다.")
          .font(.system(size: 23, weight: .semibold))
          .foregroundStyle(Color.primitives.gray500)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.top, 10)
    } else {
      LazyVStack(spacing: 10) {
        ForEach(events) { event in
          ScheduleCard(event: event) {
            onTapEvent(event)
          }
          .contextMenu {
            Button {
              onTapEvent(event)
            } label: {
              Label("수정", systemImage: "pencil")
            }

            Button(role: .destructive) {
              onRequestDelete(event)
            } label: {
              Label("삭제", systemImage: "trash")
            }
          }
        }
      }
    }
  }

  var selectedDateTitle: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "M. d. E"
    return formatter.string(from: selectedDate)
  }
}
