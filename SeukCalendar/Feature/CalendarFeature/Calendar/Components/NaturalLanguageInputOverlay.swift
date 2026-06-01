import DesignSystem
import SwiftUI

struct NaturalLanguageInputOverlay: View {
  @Binding var text: String

  let isLoading: Bool
  let errorMessage: String?
  let onCancel: () -> Void
  let onConfirm: () -> Void

  var body: some View {
    ZStack {
      Color.black.opacity(0.38)
        .ignoresSafeArea()

      VStack(spacing: 18) {
        header
        inputField
        errorMessageView
        actionButtons
      }
      .padding(20)
      .background(Color.primitives.white)
      .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
      .shadow(color: .black.opacity(0.18), radius: 24, x: 0, y: 12)
      .padding(.horizontal, 24)
    }
  }
}

private extension NaturalLanguageInputOverlay {
  var header: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("AI 일정 추가")
        .font(.system(size: 22, weight: .bold))
        .foregroundStyle(Color.primitives.black)

      Text("일정을 자연어로 입력하면 등록 시트에 자동으로 채워집니다.")
        .font(.system(size: 14, weight: .regular))
        .foregroundStyle(Color.primitives.gray600)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var inputField: some View {
    TextField(
      "예: 다음주 화요일 오후 2시에 강남역에서 클라이언트 미팅",
      text: $text,
      axis: .vertical
    )
    .font(.system(size: 16, weight: .regular))
    .lineLimit(4 ... 8)
    .padding(14)
    .background(Color.primitives.gray100)
    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    #if os(iOS)
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()
    #endif
  }

  @ViewBuilder
  var errorMessageView: some View {
    if let errorMessage {
      Text(errorMessage)
        .font(.system(size: 13, weight: .medium))
        .foregroundStyle(Color.calendar.red)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  var actionButtons: some View {
    HStack(spacing: 10) {
      Button("취소") {
        onCancel()
      }
      .buttonStyle(.bordered)
      .disabled(isLoading)

      Button {
        onConfirm()
      } label: {
        if isLoading {
          ProgressView()
            .controlSize(.small)
        } else {
          Text("확인")
        }
      }
      .buttonStyle(.borderedProminent)
      .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
  }
}
