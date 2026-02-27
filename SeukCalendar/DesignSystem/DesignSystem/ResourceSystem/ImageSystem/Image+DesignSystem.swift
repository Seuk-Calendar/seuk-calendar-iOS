//import SwiftUI
//
//public enum PoolImage {
//  public enum ImageFamily: String, CaseIterable {
//    case etc = "Etc"
//    case icon12 = "Icon_12px"
//    case icon16 = "Icon_16px"
//    case icon20 = "Icon_20px"
//    case icon24 = "Icon_24px"
//    case icon30 = "Icon_30px"
//    case icon32 = "Icon_32px"
//  }
//}
//
//// MARK: - Etc
//
//public extension PoolImage {
//  enum Etc {
//    public static let copy_circle: ImageResource = ImageResource(.etc, name: "copy_circle")
//    public static let demand_tooltip: ImageResource = ImageResource(.etc, name: "demand_tooltip")
//    public static let fab: ImageResource = ImageResource(.etc, name: "fab")
//    public static let gmail: ImageResource = ImageResource(.etc, name: "gmail")
//    public static let google: ImageResource = ImageResource(.etc, name: "google")
//    public static let instagram: ImageResource = ImageResource(.etc, name: "instagram")
//    public static let kakao: ImageResource = ImageResource(.etc, name: "kakao")
//    public static let message: ImageResource = ImageResource(.etc, name: "message")
//    public static let naver: ImageResource = ImageResource(.etc, name: "naver")
//    public static let three_dot_circle: ImageResource = ImageResource(.etc, name: "three_dot_circle")
//    public static let x_twitter: ImageResource = ImageResource(.etc, name: "x_twitter")
//    public static let test_bunny_thumbnail: ImageResource = ImageResource(.etc, name: "test_bunny_thumbnail")
//    public static let test_car_thumbnail: ImageResource = ImageResource(.etc, name: "test_car_thumbnail")
//    public static let test_cake_thumbnail: ImageResource = ImageResource(.etc, name: "test_cake_thumbnail")
//    public static let uploadBg: ImageResource = ImageResource(.etc, name: "upload-bg")
//  }
//}
//
//public extension ImageResource {
//  static var etc: PoolImage.Etc.Type { PoolImage.Etc.self }
//}
//
//// MARK: - Icon12
//
//public extension PoolImage {
//  enum Icon12 {
//    public static let arrow_left: ImageResource = ImageResource(.icon12, name: "arrow_left")
//  }
//}
//
//public extension ImageResource {
//  static var icon12: PoolImage.Icon12.Type { PoolImage.Icon12.self }
//}
//
//// MARK: - Icon16
//
//public extension PoolImage {
//  enum Icon16 {
//    public static let minus: ImageResource = ImageResource(.icon16, name: "minus")
//    public static let plus: ImageResource = ImageResource(.icon16, name: "plus")
//    public static let radio_off: ImageResource = ImageResource(.icon16, name: "radio_off")
//    public static let radio_on: ImageResource = ImageResource(.icon16, name: "radio_on")
//  }
//}
//
//public extension ImageResource {
//  static var icon16: PoolImage.Icon16.Type { PoolImage.Icon16.self }
//}
//
//// MARK: - Icon20
//
//public extension PoolImage {
//  enum Icon20 {
//    public static let arrow_down: ImageResource = ImageResource(.icon20, name: "arrow_down")
//    public static let arrow_left: ImageResource = ImageResource(.icon20, name: "arrow_left")
//    public static let arrow_right: ImageResource = ImageResource(.icon20, name: "arrow_right")
//    public static let arrow_up: ImageResource = ImageResource(.icon20, name: "arrow_up")
//    public static let arrow_leftup: ImageResource = ImageResource(.icon20, name: "arrow_leftup")
//    public static let bookmark: ImageResource = ImageResource(.icon20, name: "bookmark")
//    public static let chat: ImageResource = ImageResource(.icon20, name: "chat")
//    public static let check_circle: ImageResource = ImageResource(.icon20, name: "check_circle")
//    public static let check: ImageResource = ImageResource(.icon20, name: "check")
//    public static let eye_close: ImageResource = ImageResource(.icon20, name: "eye_close")
//    public static let eye: ImageResource = ImageResource(.icon20, name: "eye")
//    public static let heart: ImageResource = ImageResource(.icon20, name: "heart")
//    public static let search: ImageResource = ImageResource(.icon20, name: "search")
//    public static let send: ImageResource = ImageResource(.icon20, name: "send")
//    public static let xmark: ImageResource = ImageResource(.icon20, name: "xmark")
//  }
//}
//
//public extension ImageResource {
//  static var icon20: PoolImage.Icon20.Type { PoolImage.Icon20.self }
//}
//
//// MARK: - Icon24
//
//public extension PoolImage {
//  enum Icon24 {
//    public static let arrow_down: ImageResource = ImageResource(.icon24, name: "arrow_down")
//    public static let arrow_left: ImageResource = ImageResource(.icon24, name: "arrow_left")
//    public static let arrow_right: ImageResource = ImageResource(.icon24, name: "arrow_right")
//    public static let arrow_up: ImageResource = ImageResource(.icon24, name: "arrow_up")
//    public static let bell: ImageResource = ImageResource(.icon24, name: "bell")
//    public static let bell_on: ImageResource = ImageResource(.icon24, name: "bell_on")
//    public static let camera: ImageResource = ImageResource(.icon24, name: "camera")
//    public static let chat: ImageResource = ImageResource(.icon24, name: "chat")
//    public static let check_circle: ImageResource = ImageResource(.icon24, name: "check_circle")
//    public static let heart_fill: ImageResource = ImageResource(.icon24, name: "heart_fill")
//    public static let heart: ImageResource = ImageResource(.icon24, name: "heart")
//    public static let effect: ImageResource = ImageResource(.icon24, name: "effect")
//    public static let image: ImageResource = ImageResource(.icon24, name: "image")
//    public static let music: ImageResource = ImageResource(.icon24, name: "music")
//    public static let search: ImageResource = ImageResource(.icon24, name: "search")
//    public static let share: ImageResource = ImageResource(.icon24, name: "share")
//    public static let three_dot: ImageResource = ImageResource(.icon24, name: "three_dot")
//    public static let timer: ImageResource = ImageResource(.icon24, name: "timer")
//    public static let trash: ImageResource = ImageResource(.icon24, name: "trash")
//    public static let xmark_mini: ImageResource = ImageResource(.icon24, name: "xmark_mini")
//    public static let xmark: ImageResource = ImageResource(.icon24, name: "xmark")
//  }
//}
//
//public extension ImageResource {
//  static var icon24: PoolImage.Icon24.Type { PoolImage.Icon24.self }
//}
//
//// MARK: - Icon30
//
//public extension PoolImage {
//  enum Icon30 {
//    public static let copy: ImageResource = ImageResource(.icon30, name: "copy")
//  }
//}
//
//public extension ImageResource {
//  static var icon30: PoolImage.Icon30.Type { PoolImage.Icon30.self }
//}
//
//// MARK: - Icon32
//
//public extension PoolImage {
//  enum Icon32 {
//    public static let effect: ImageResource = ImageResource(.icon32, name: "effect")
//    public static let music: ImageResource = ImageResource(.icon32, name: "music")
//    public static let refresh: ImageResource = ImageResource(.icon32, name: "refresh")
//    public static let timer: ImageResource = ImageResource(.icon32, name: "timer")
//  }
//}
//
//public extension ImageResource {
//  static var icon32: PoolImage.Icon32.Type { PoolImage.Icon32.self }
//}
//
//// MARK: - public: UIView 호환
//
//public extension UIImage {
//  convenience init?(_ imageFamily: PoolImage.ImageFamily, name: String) {
//    self.init(named: "\(imageFamily.rawValue)/\(name)", in: .module, with: nil)
//  }
//}
//
//// MARK: - fileprivate
//
//fileprivate extension ImageResource {
//  init(_ imageFamily: PoolImage.ImageFamily, name: String) {
//    self.init(name: "\(imageFamily.rawValue)/\(name)", bundle: .module)
//  }
//}
