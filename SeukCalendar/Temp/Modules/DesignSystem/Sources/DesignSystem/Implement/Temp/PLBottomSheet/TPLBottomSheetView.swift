//
//  TPLBottomSheetView.swift
//  Pool
//
//  Created by YoungK on 2/5/26.
//

import SwiftUI

struct TPLBottomSheetView<Content: View>: View {
  let header: String?
  let content: Content
  var dragGesture: AnyGesture<DragGesture.Value>?

  init(
    header: String? = nil,
    dragGesture: AnyGesture<DragGesture.Value>? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.header = header
    self.dragGesture = dragGesture
    self.content = content()
  }

  var body: some View {
    VStack(spacing: 0) {
      handleBarSection()

      if let header {
        headerSection(title: header)
      }

      contentSection()
    }
    .background(PoolColor.Backgrounds.tertiary)
    .clipShape(
      UnevenRoundedRectangle(
        topLeadingRadius: Radius.rds600,
        topTrailingRadius: Radius.rds600
      )
    )
  }

  @ViewBuilder
  private func handleBarSection() -> some View {
    RoundedRectangle(cornerRadius: Radius.rds100)
      .fill(PoolColor.Labels.secondary)
      .frame(width: 40, height: 5)
      .frame(maxWidth: .infinity)
      .padding(.top, Spacing.sp300)
      .padding(.bottom, Spacing.sp100)
      .background(PoolColor.Backgrounds.tertiary)
      .contentShape(Rectangle())
      .applyGesture(dragGesture)
  }

  @ViewBuilder
  private func headerSection(title: String) -> some View {
    VStack(spacing: 0) {
      Text(title)
        .font(Label2.bold)
        .foregroundStyle(PoolColor.Labels.primary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.sp300)

      Divider()
        .background(PoolColor.Fills.quaternary)
    }
    .background(PoolColor.Backgrounds.tertiary)
    .contentShape(Rectangle())
    .applyGesture(dragGesture)
  }

  @ViewBuilder
  private func contentSection() -> some View {
    ZStack {
      // 컨텐츠 크기와 별개로 sheet 영역을 확보하기 위함
      PoolColor.Backgrounds.tertiary
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      content
    }
    .safeAreaPadding(.bottom)
  }
}

// MARK: - Gesture Helper

private extension View {
  @ViewBuilder
  func applyGesture(_ gesture: AnyGesture<DragGesture.Value>?) -> some View {
    if let gesture {
      self.gesture(gesture)
    } else {
      self
    }
  }
}

#Preview {
  @Previewable @State var isPresented = true

  ZStack {
    Color.clear.ignoresSafeArea()

    Button("시트 열기") { isPresented.toggle() }
  }
  .tplBottomSheet(isPresented: $isPresented, header: "댓글") {
    TestCommentListView()
  }
}
