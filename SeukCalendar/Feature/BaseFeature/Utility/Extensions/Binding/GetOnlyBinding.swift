import SwiftUI

/// 읽기 전용 Binding wrapper
///
/// - 읽기만 가능하고 쓰기가 불가능함을 컴파일 타임에 보장
///
/// ```swift
/// @GetOnlyBinding var status: AVPlayerItem.Status
///
/// // 사용
/// if status == .readyToPlay { ... }  // ✅
/// status = .failed                    // ❌ 컴파일 에러
/// ```
@propertyWrapper
public struct GetOnlyBinding<Value> {
  private let binding: Binding<Value>

  public init(_ binding: Binding<Value>) {
    self.binding = binding
  }

  /// GetOnlyBinding을 직접 받을 때 사용
  public init(_ getOnlyBinding: GetOnlyBinding<Value>) {
    self.binding = getOnlyBinding.binding
  }

  /// get만 가능
  public var wrappedValue: Value {
    get { binding.wrappedValue }
  }

  public var projectedValue: GetOnlyBinding<Value> { self }
}
