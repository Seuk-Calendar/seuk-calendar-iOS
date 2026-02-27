//
//  TPLBottomSheetModifier.swift
//  Pool
//
//  Created by YoungK on 2/7/26.
//

import SwiftUI

private struct TPLBottomSheetItemModifier<Item: Identifiable, SheetContent: View>: ViewModifier {
  @Binding var item: Item?
  let header: String?
  let positions: [BottomSheetPosition]
  let initialPosition: BottomSheetPosition
  let configuration: BottomSheetConfiguration
  let onAppear: (() -> Void)?
  let onDismiss: (() -> Void)?
  let onChangeHeight: ((CGFloat) -> Void)?
  let onPositionChange: ((BottomSheetPosition) -> Void)?
  let sheetContent: (Item) -> SheetContent

  private var isPresented: Binding<Bool> {
    Binding(
      get: { item != nil },
      set: { if !$0 { item = nil } }
    )
  }

  func body(content: Content) -> some View {
    content.overlay {
      if let currentItem = item {
        TPLBottomSheet(
          isPresented: isPresented,
          header: header,
          positions: positions,
          initialPosition: initialPosition,
          configuration: configuration,
          onAppear: onAppear,
          onDismiss: onDismiss,
          onChangeHeight: onChangeHeight,
          onPositionChange: onPositionChange,
          sheetContent: sheetContent(currentItem)
        )
      }
    }
  }
}

private struct TPLBottomSheetBoolModifier<SheetContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  let header: String?
  let positions: [BottomSheetPosition]
  let initialPosition: BottomSheetPosition
  let configuration: BottomSheetConfiguration
  let onAppear: (() -> Void)?
  let onDismiss: (() -> Void)?
  let onChangeHeight: ((CGFloat) -> Void)?
  let onPositionChange: ((BottomSheetPosition) -> Void)?
  let sheetContent: () -> SheetContent

  func body(content: Content) -> some View {
    content.overlay {
      if isPresented {
        TPLBottomSheet(
          isPresented: $isPresented,
          header: header,
          positions: positions,
          initialPosition: initialPosition,
          configuration: configuration,
          onAppear: onAppear,
          onDismiss: onDismiss,
          onChangeHeight: onChangeHeight,
          onPositionChange: onPositionChange,
          sheetContent: sheetContent()
        )
      }
    }
  }
}

// MARK: - View Extension

public extension View {
  func tplBottomSheet<Item: Identifiable, Content: View>(
    item: Binding<Item?>,
    header: String? = nil,
    positions: [BottomSheetPosition] = [.medium, .large],
    initialPosition: BottomSheetPosition = .medium,
    configuration: BottomSheetConfiguration = .init(),
    onAppear: (() -> Void)? = nil,
    onDismiss: (() -> Void)? = nil,
    onChangeHeight: ((CGFloat) -> Void)? = nil,
    onPositionChange: ((BottomSheetPosition) -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View {
    modifier(
      TPLBottomSheetItemModifier(
        item: item,
        header: header,
        positions: positions,
        initialPosition: initialPosition,
        configuration: configuration,
        onAppear: onAppear,
        onDismiss: onDismiss,
        onChangeHeight: onChangeHeight,
        onPositionChange: onPositionChange,
        sheetContent: content
      )
    )
  }

  func tplBottomSheet<Content: View>(
    isPresented: Binding<Bool>,
    header: String? = nil,
    positions: [BottomSheetPosition] = [.medium, .large],
    initialPosition: BottomSheetPosition = .medium,
    configuration: BottomSheetConfiguration = .init(),
    onAppear: (() -> Void)? = nil,
    onDismiss: (() -> Void)? = nil,
    onChangeHeight: ((CGFloat) -> Void)? = nil,
    onPositionChange: ((BottomSheetPosition) -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    modifier(
      TPLBottomSheetBoolModifier(
        isPresented: isPresented,
        header: header,
        positions: positions,
        initialPosition: initialPosition,
        configuration: configuration,
        onAppear: onAppear,
        onDismiss: onDismiss,
        onChangeHeight: onChangeHeight,
        onPositionChange: onPositionChange,
        sheetContent: content
      )
    )
  }
}
