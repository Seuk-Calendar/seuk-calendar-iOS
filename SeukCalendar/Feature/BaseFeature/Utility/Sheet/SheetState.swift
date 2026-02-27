import DesignSystem
import Navigation
import SwiftUI

/// 피쳐들에서 바텀시트의 현재 상태를 관찰하기 위한 Observable 객체
///
/// ContentView에서 tplBottomSheet의 콜백을 통해 업데이트되며,
/// 하위 뷰에서는 Environment를 통해 읽기 전용으로 접근합니다.
@Observable
public final class SheetState {
  /// 현재 표시 중인 시트
  public private(set) var presentedSheet: SheetDestination?

  /// 현재 시트 높이 (px)
  public private(set) var height: CGFloat = 0

  /// 현재 시트 포지션
  public private(set) var position: BottomSheetPosition = .hidden

  /// 시트가 표시 중인지 여부
  public var isPresented: Bool { presentedSheet != nil }

  public init() {}

  // MARK: - 내부 업데이트 (ContentView에서 호출)

  public func update(presentedSheet: SheetDestination?) {
    self.presentedSheet = presentedSheet
  }

  public func update(height: CGFloat) {
    self.height = height
  }

  public func update(position: BottomSheetPosition) {
    self.position = position
  }

  public func reset() {
    presentedSheet = nil
    height = 0
    position = .hidden
  }
}
