import Combine
import UIKit

public extension NotificationCenter {
  /// 키보드가 나타날 때 높이를 전달하는 Publisher
  var keyboardWillShowPublisher: AnyPublisher<CGFloat, Never> {
    self.publisher(for: UIResponder.keyboardWillShowNotification)
      .compactMap { notification in
        let rect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        return rect?.height
      }
      .eraseToAnyPublisher()
  }

  /// 키보드가 사라질 때 0을 전달하는 Publisher
  var keyboardWillHidePublisher: AnyPublisher<CGFloat, Never> {
    self.publisher(for: UIResponder.keyboardWillHideNotification)
      .map { _ in CGFloat(0) }
      .eraseToAnyPublisher()
  }
}
