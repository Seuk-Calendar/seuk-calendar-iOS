//
//  TPLBottomSheetPreview.swift
//  Pool
//
//  Created by YoungK on 2/7/26.
//

import SwiftUI

#Preview {
  @Previewable @State var isPresented = true

  ZStack {
    Color.black.ignoresSafeArea()

    Button("바텀시트 열기") { isPresented = true }
  }
  .tplBottomSheet(
    isPresented: $isPresented,
    header: "댓글",
    configuration: .init(
      isTapToDismissEnabled: true
    )
  ) {
    TestCommentListView()
  }
}
