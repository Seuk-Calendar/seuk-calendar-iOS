//
//  BottomSheetConfiguration.swift
//  Pool
//
//  Created by YoungK on 2/7/26.
//

import SwiftUI

public struct BottomSheetConfiguration {
  /// 시트 전환 애니메이션
  var animation: Animation = .spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1)
  // 애니메이션 길이
  var animationDuration: Double = 0.5
  /// 강하게 스와이프 시 최고/최저 포지션으로 점프
  var isFlickThroughEnabled: Bool = true
  /// 아래로 많이 드래그하면 시트 닫힘
  var isSwipeToDismissEnabled: Bool = false
  /// 시트 외부(배경) 탭으로 닫힘
  var isTapToDismissEnabled: Bool = false
  /// 드래그 인디케이터(핸들바) 표시 여부
  var isDragIndicatorShown: Bool = true
  /// FlickThrough / SwipeToDismiss 판단 기준 (0.0 ~ 1.0)
  var threshold: CGFloat = 0.20
  /// 시트 너비 설정
  var sheetWidth: BottomSheetWidth = .platformDefault

  public init(
    animationDuration: Double = 0.5,
    isFlickThroughEnabled: Bool = true,
    isSwipeToDismissEnabled: Bool = true,
    isTapToDismissEnabled: Bool = true,
    isDragIndicatorShown: Bool = true,
    threshold: CGFloat = 0.20,
    sheetWidth: BottomSheetWidth = .platformDefault
  ) {
    self.animationDuration = animationDuration
    self.animation = .spring(response: animationDuration, dampingFraction: 0.75, blendDuration: 1)
    self.isFlickThroughEnabled = isFlickThroughEnabled
    self.isSwipeToDismissEnabled = isSwipeToDismissEnabled
    self.isTapToDismissEnabled = isTapToDismissEnabled
    self.isDragIndicatorShown = isDragIndicatorShown
    self.threshold = threshold
    self.sheetWidth = sheetWidth
  }
}
