//
//  TestCommentListView.swift
//  Pool
//
//  Created by YoungK on 2/5/26.
//

import SwiftUI

public struct TestCommentListView: View {
  public init() {}

  public var body: some View {
    VStack(spacing: 0) {
      emptySection()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      inputSection()
    }
    .background(PoolColor.Backgrounds.tertiary)
  }

  @ViewBuilder
  private func emptySection() -> some View {
    VStack(spacing: Spacing.sp400) {
      Text("아직 댓글이 없습니다")
        .font(Heading5.bold)
        .foregroundStyle(PoolColor.Labels.secondary)

      Text("댓글을 남겨보세요.")
        .font(Body2.regular)
        .foregroundStyle(PoolColor.Labels.tertiary)
    }
  }

  @ViewBuilder
  private func inputSection() -> some View {
    HStack(spacing: 10) {
      Circle()
        .foregroundStyle(PoolColor.Etc.buttonDisabeldBg)
        .frame(40)

      RoundedRectangle(cornerRadius: 8)
        .foregroundStyle(PoolColor.Etc.buttonDisabeldBg)
        .frame(height: 48)
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 12)
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
