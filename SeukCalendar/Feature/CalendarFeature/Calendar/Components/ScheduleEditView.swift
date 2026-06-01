import DesignSystem
import SwiftUI

struct ScheduleEditView: View {
  let event: CalendarEvent
  let isSaving: Bool
  let isDeleting: Bool
  let errorMessage: String?
  let onSave: (CalendarViewModel.ScheduleEditDraft) -> Void
  let onDelete: () async -> Bool

  @State private var draft: CalendarViewModel.ScheduleEditDraft
  @State private var isDeleteConfirmationPresented = false

  init(
    event: CalendarEvent,
    isSaving: Bool,
    isDeleting: Bool,
    errorMessage: String?,
    onSave: @escaping (CalendarViewModel.ScheduleEditDraft) -> Void,
    onDelete: @escaping () async -> Bool
  ) {
    self.event = event
    self.isSaving = isSaving
    self.isDeleting = isDeleting
    self.errorMessage = errorMessage
    self.onSave = onSave
    self.onDelete = onDelete
    _draft = State(initialValue: CalendarViewModel.ScheduleEditDraft(event: event))
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 16) {
        fieldSection
        errorMessageView
        deleteButton
      }
      .padding(20)
    }
    .navigationTitle("일정 편집")
    #if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
    #endif
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("저장") {
            onSave(draft)
          }
          .disabled(isMutating || !canSave)
        }
      }
      .alert("정말로 삭제하시겠습니까?", isPresented: $isDeleteConfirmationPresented) {
        Button("삭제", role: .destructive) {
          Task {
            _ = await onDelete()
          }
        }

        Button("취소", role: .cancel) {}
      } message: {
        Text("'\(event.title)' 일정을 삭제합니다.")
      }
      .overlay {
        if isMutating {
          ProgressView()
            .padding(18)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
      }
      .onChange(of: draft.isAllDay) { _, isAllDay in
        if isAllDay {
          draft.startTime = ""
        } else if draft.startTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          draft.startTime = defaultStartTime
        }
      }
  }
}

private extension ScheduleEditView {
  var fieldSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      labeledTextField("제목", text: $draft.title)
      labeledTextField("날짜", text: $draft.dateString, helper: "yyyy-MM-dd")

      Toggle("종일 일정", isOn: $draft.isAllDay)
        .font(.system(size: 15, weight: .medium))

      if !draft.isAllDay {
        labeledTextField("시작 시간", text: $draft.startTime, helper: "HH:mm")
      }

      labeledTextField("소요 시간(분)", text: $draft.durationMinutesText)
      #if os(iOS)
        .keyboardType(.numberPad)
      #endif

      labeledTextField("장소", text: $draft.location)

      VStack(alignment: .leading, spacing: 8) {
        Text("메모")
          .font(.system(size: 13, weight: .semibold))
          .foregroundStyle(Color.primitives.gray700)

        TextField("메모", text: $draft.notes, axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .lineLimit(3 ... 6)
      }
    }
  }

  @ViewBuilder
  var errorMessageView: some View {
    if let errorMessage {
      Text(errorMessage)
        .font(.system(size: 13, weight: .medium))
        .foregroundStyle(Color.calendar.red)
    }
  }

  var deleteButton: some View {
    Button(role: .destructive) {
      isDeleteConfirmationPresented = true
    } label: {
      Text("일정 삭제")
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(Color.semanticExtensions.Content.contentOnColor)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
          RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(Color.semanticExtensions.Background.backgroundNegative)
        )
    }
    .buttonStyle(.plain)
    .disabled(isMutating)
    .opacity(isMutating ? 0.45 : 1)
    .padding(.top, 28)
  }

  func labeledTextField(
    _ title: String,
    text: Binding<String>,
    helper: String? = nil
  ) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 6) {
        Text(title)
          .font(.system(size: 13, weight: .semibold))
          .foregroundStyle(Color.primitives.gray700)

        if let helper {
          Text(helper)
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(Color.primitives.gray500)
        }
      }

      TextField(title, text: text)
        .textFieldStyle(.roundedBorder)
      #if os(iOS)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
      #endif
    }
  }

  var canSave: Bool {
    !draft.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !draft.dateString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !draft.durationMinutesText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && (draft.isAllDay || !draft.startTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
  }

  var isMutating: Bool {
    isSaving || isDeleting
  }

  var defaultStartTime: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: event.startDate)
  }
}
