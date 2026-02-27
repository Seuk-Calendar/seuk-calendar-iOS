//
//  TPLBottomSheet.swift
//  Pool
//
//  Created by YoungK on 2/7/26.
//

import SwiftUI

/// 시트 로직 전체를 담당하는 View
/// 제스처 처리, 포지션 스냅, 스크롤-드래그 연동, 애니메이션을 통합 관리합니다.
struct TPLBottomSheet<SheetContent: View>: View {
  @Binding var isPresented: Bool
  let header: String?
  let positions: [BottomSheetPosition]
  let initialPosition: BottomSheetPosition
  let configuration: BottomSheetConfiguration
  let onAppear: (() -> Void)?
  let onDismiss: (() -> Void)?
  let onChangeHeight: ((CGFloat) -> Void)?
  let onPositionChange: ((BottomSheetPosition) -> Void)?
  let sheetContent: SheetContent

  // MARK: - State

  @GestureState private var isDragging: Bool = false
  @State private var lastDragValue: DragGesture.Value?

  @State private var currentPosition: BottomSheetPosition = .hidden
  @State private var translation: CGFloat = 0
  @State private var screenHeight: CGFloat = 0
  @State private var isAnimatingPresentation: Bool = false

  // 컨텐트 스크롤 <-> 시트 드래그 연동에 필요
  @State private var contentAtTop: Bool = true
  @State private var isDraggingSheet: Bool = false

  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.verticalSizeClass) private var verticalSizeClass

  // MARK: - Computed Properties

  private var isIPad: Bool {
    horizontalSizeClass == .regular && verticalSizeClass == .regular
  }

  private var isLandscape: Bool {
    horizontalSizeClass == .regular && verticalSizeClass == .compact
  }

  private var minHeight: CGFloat { 50 }
  private var maxHeight: CGFloat { screenHeight * 0.95 }

  /// 현재 포지션 기반 높이에서 드래그 오프셋을 뺀 실제 시트 높이
  private var sheetHeight: CGFloat {
    min(max(currentPosition.height(in: screenHeight) - translation, minHeight), maxHeight)
  }

  // MARK: - Body

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .bottom) {
        // TapToDismiss를 위한 배경 영역
        if configuration.isTapToDismissEnabled, isAnimatingPresentation {
          Color.clear
            .contentShape(Rectangle())
            .ignoresSafeArea()
            .onTapGesture { dismiss() }
        }

        // 시트 영역
        VStack(spacing: 0) {
          Spacer()

          TPLBottomSheetView(
            header: header,
            dragGesture: handleBarAnyGesture
          ) {
            sheetContent
              .scrollDisabled(isDraggingSheet)
              .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
              } action: { _, offsetY in
                contentAtTop = offsetY <= 0
              }
              .simultaneousGesture(contentDragGesture)
          }
          .frame(
            width: configuration.sheetWidth.width(
              in: geometry.size.width,
              isIPad: isIPad,
              isLandscape: isLandscape
            ),
            height: sheetHeight
          )
          .offset(y: isAnimatingPresentation ? 0 : screenHeight)
        }
        .ignoresSafeArea(edges: .bottom)
      }
      .onAppear {
        screenHeight = geometry.size.height
          + geometry.safeAreaInsets.top
          + geometry.safeAreaInsets.bottom
        currentPosition = initialPosition
        withAnimation(configuration.animation) {
          isAnimatingPresentation = true
        }
        onAppear?()
        onChangeHeight?(initialPosition.height(in: screenHeight))
        onPositionChange?(initialPosition)
      }
    }
    .animation(configuration.animation, value: currentPosition)
    .animation(configuration.animation, value: translation)
    .animation(configuration.animation, value: isAnimatingPresentation)
    .onChange(of: isDragging) { _, newIsDragging in
      if !newIsDragging, let lastValue = lastDragValue {
        dragPositionSwitch(value: lastValue)
        translation = 0
        lastDragValue = nil
        isDraggingSheet = false
        // 드래그가 끝났을 때, 포지션 변화가 없는 경우에도 height를 방출할 수 있도록
        // isAnimatingPresentaion: dismiss중이 아닐 때
        if isAnimatingPresentation {
          onChangeHeight?(currentPosition.height(in: screenHeight))
        }
      }
    }
  }

  private func dismiss() {
    isAnimatingPresentation = false
    onChangeHeight?(0)
    // 애니메이션 완료 후 닫기
    DispatchQueue.main.asyncAfter(deadline: .now() + configuration.animationDuration) {
      isPresented = false
      onDismiss?()
    }
  }
}

// MARK: - Gesture

extension TPLBottomSheet {
  /// 핸들바 제스처
  private var handleBarAnyGesture: AnyGesture<DragGesture.Value> {
    AnyGesture(
      DragGesture()
        .onChanged { value in
          lastDragValue = value
          translation = value.translation.height
          onChangeHeight?(sheetHeight)
        }
        .updating($isDragging) { _, state, _ in
          state = true
        }
    )
  }

  /// 컨텐트가 스크롤 최상단일 때, 시트를 드래그하기 위한 제스처
  private var contentDragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        guard contentAtTop, value.translation.height > 0 else { return }
        isDraggingSheet = true
        lastDragValue = value
        translation = value.translation.height
        onChangeHeight?(sheetHeight)
      }
      .updating($isDragging) { _, state, _ in
        state = true
      }
  }
}

// MARK: - Switch Position

extension TPLBottomSheet {
  private func dragPositionSwitch(value: DragGesture.Value) {
    let dragRatio = value.translation.height / screenHeight

    if configuration.isFlickThroughEnabled {
      flickThroughSwitch(dragRatio: dragRatio)
    } else {
      defaultSwitch(dragRatio: dragRatio)
    }
  }

  /// FlickThrough: threshold 기반 포지션 전환
  private func flickThroughSwitch(dragRatio: CGFloat) {
    let threshold = configuration.threshold

    if dragRatio <= -0.1, dragRatio > -threshold {
      // 위로 한 단계
      onePositionUp()
    } else if dragRatio <= -threshold {
      // 최고 포지션으로 점프
      switchToHighest()
    } else if dragRatio >= 0.1, dragRatio < threshold {
      // 아래로 한 단계
      onePositionDown()
    } else if dragRatio >= threshold, configuration.isSwipeToDismissEnabled {
      dismiss()
    } else if dragRatio >= threshold {
      // 최저 포지션으로 점프
      switchToLowest()
    }
  }

  /// FlickThrough 비활성화 시 한 단계 씩 단순 전환
  private func defaultSwitch(dragRatio: CGFloat) {
    let threshold = configuration.threshold

    if dragRatio <= -0.1 {
      onePositionUp()
    } else if dragRatio >= threshold, configuration.isSwipeToDismissEnabled {
      dismiss()
    } else if dragRatio >= 0.1 {
      onePositionDown()
    }
  }

  private func onePositionUp() {
    let currentHeight = currentPosition.height(in: screenHeight)
    if let target = getSwitchablePositions().first(where: { $0.height > currentHeight }) {
      currentPosition = target.position
      onPositionChange?(currentPosition)
    }
  }

  private func onePositionDown() {
    let currentHeight = currentPosition.height(in: screenHeight)
    if let target = getSwitchablePositions().last(where: { $0.height < currentHeight }) {
      currentPosition = target.position
      onPositionChange?(currentPosition)
    }
  }

  private func switchToHighest() {
    let currentHeight = currentPosition.height(in: screenHeight)
    if let highest = getSwitchablePositions().last, highest.height > currentHeight {
      currentPosition = highest.position
      onPositionChange?(currentPosition)
    }
  }

  private func switchToLowest() {
    let currentHeight = currentPosition.height(in: screenHeight)
    if let lowest = getSwitchablePositions().first, lowest.height < currentHeight {
      currentPosition = lowest.position
      onPositionChange?(currentPosition)
    }
  }

  /// 변경 가능한 포지션 목록(현재 포지션과 hidden 제외)
  private func getSwitchablePositions() -> [(height: CGFloat, position: BottomSheetPosition)] {
    positions
      .filter { !$0.isHidden && $0 != currentPosition }
      .map { (height: $0.height(in: screenHeight), position: $0) }
      .sorted { $0.height < $1.height }
  }
}
