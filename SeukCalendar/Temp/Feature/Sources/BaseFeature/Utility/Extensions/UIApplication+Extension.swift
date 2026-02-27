import UIKit

public extension UIApplication {
  var rootWindow: UIWindow? {
    UIApplication
      .shared
      .connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow }
      .last
  }

  var safeAreaInsets: UIEdgeInsets {
    rootWindow?.safeAreaInsets ?? .zero
  }

  var rootViewController: UIViewController? {
    return getTopViewController(from: rootWindow?.rootViewController)
  }

  private func getTopViewController(from viewController: UIViewController?) -> UIViewController? {
    if let nav = viewController as? UINavigationController {
      return getTopViewController(from: nav.visibleViewController)
    } else if let tab = viewController as? UITabBarController {
      return getTopViewController(from: tab.selectedViewController)
    } else if let presented = viewController?.presentedViewController {
      return getTopViewController(from: presented)
    }
    return viewController
  }
}
