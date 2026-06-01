import DesignSystem
import SwiftUI

struct ParsedEventEditorSheet: View {
  let draft: CalendarViewModel.ParsedEventDraft?
  let isSaving: Bool
  let errorMessage: String?
  let onUpdateTitle: (String) -> Void
  let onUpdateDateString: (String) -> Void
  let onUpdateStartTime: (String) -> Void
  let onUpdateDurationMinutes: (String) -> Void
  let onUpdateLocation: (String) -> Void
  let onUpdateNotes: (String) -> Void
  let onUpdateIsAllDay: (Bool) -> Void
  let onAddAlarm: (CalendarViewModel.AlarmPreset) -> Void
  let onRemoveAlarm: (Int) -> Void
  let onCancel: () -> Void
  let onSave: () -> Void

  var body: some View {
    NavigationStack {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          if draft == nil {
            emptyState
          } else {
            formContent
          }
        }
        .padding(20)
      }
      .navigationTitle("일정 등록")
      #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
      #endif
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("취소") {
              onCancel()
            }
            .disabled(isSaving)
          }

          ToolbarItem(placement: .confirmationAction) {
            Button("저장") {
              onSave()
            }
            .disabled(draft == nil || isSaving)
          }
        }
        .overlay {
          if isSaving {
            ProgressView()
              .padding(18)
              .background(.ultraThinMaterial)
              .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
          }
        }
    }
  }
}

private extension ParsedEventEditorSheet {
  var emptyState: some View {
    Text("분석 결과가 없습니다.")
      .font(.system(size: 15, weight: .medium))
      .foregroundStyle(Color.primitives.gray600)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.vertical, 40)
  }

  var formContent: some View {
    VStack(alignment: .leading, spacing: 16) {
      fieldSection
      alarmSection
      errorMessageView
    }
  }

  var fieldSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      labeledTextField("제목", text: titleBinding)
      labeledTextField("날짜", text: dateStringBinding, helper: "yyyy-MM-dd")

      Toggle("종일 일정", isOn: isAllDayBinding)
        .font(.system(size: 15, weight: .medium))

      if !(draft?.isAllDay ?? true) {
        labeledTextField("시작 시간", text: startTimeBinding, helper: "HH:mm")
      }

      labeledTextField("소요 시간(분)", text: durationMinutesBinding)
      #if os(iOS)
        .keyboardType(.numberPad)
      #endif

      labeledTextField("장소", text: locationBinding)

      VStack(alignment: .leading, spacing: 8) {
        Text("메모")
          .font(.system(size: 13, weight: .semibold))
          .foregroundStyle(Color.primitives.gray700)

        TextField("메모", text: notesBinding, axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .lineLimit(3 ... 6)
      }
    }
  }

  var alarmSection: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(spacing: 8) {
        Text("알림")
          .font(.system(size: 15, weight: .semibold))

        Spacer(minLength: 0)

        Menu {
          ForEach(CalendarViewModel.AlarmPreset.allCases) { preset in
            Button(preset.title) {
              onAddAlarm(preset)
            }
          }
        } label: {
          Label("추가", systemImage: "plus.circle")
            .font(.system(size: 13, weight: .medium))
        }
      }

      if let alarms = draft?.alarms,
         !alarms.isEmpty {
        ForEach(Array(alarms.enumerated()), id: \.offset) { index, alarm in
          HStack(spacing: 8) {
            Text(CalendarViewModel.AlarmPreset.title(for: alarm))
              .font(.system(size: 14, weight: .regular))

            Spacer(minLength: 0)

            Button(role: .destructive) {
              onRemoveAlarm(index)
            } label: {
              Image(systemName: "minus.circle")
            }
            .buttonStyle(.plain)
            .disabled(isSaving)
          }
        }
      } else {
        Text("설정된 알림이 없습니다.")
          .font(.system(size: 13, weight: .regular))
          .foregroundStyle(Color.primitives.gray500)
      }
    }
    .padding(14)
    .background(Color.primitives.gray100)
    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
  }

  @ViewBuilder
  var errorMessageView: some View {
    if let errorMessage {
      Text(errorMessage)
        .font(.system(size: 13, weight: .medium))
        .foregroundStyle(Color.calendar.red)
    }
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

  var titleBinding: Binding<String> {
    Binding(
      get: { draft?.title ?? "" },
      set: { onUpdateTitle($0) }
    )
  }

  var dateStringBinding: Binding<String> {
    Binding(
      get: { draft?.dateString ?? "" },
      set: { onUpdateDateString($0) }
    )
  }

  var startTimeBinding: Binding<String> {
    Binding(
      get: { draft?.startTime ?? "" },
      set: { onUpdateStartTime($0) }
    )
  }

  var durationMinutesBinding: Binding<String> {
    Binding(
      get: { draft?.durationMinutesText ?? "" },
      set: { onUpdateDurationMinutes($0) }
    )
  }

  var locationBinding: Binding<String> {
    Binding(
      get: { draft?.location ?? "" },
      set: { onUpdateLocation($0) }
    )
  }

  var notesBinding: Binding<String> {
    Binding(
      get: { draft?.notes ?? "" },
      set: { onUpdateNotes($0) }
    )
  }

  var isAllDayBinding: Binding<Bool> {
    Binding(
      get: { draft?.isAllDay ?? true },
      set: { onUpdateIsAllDay($0) }
    )
  }
}
