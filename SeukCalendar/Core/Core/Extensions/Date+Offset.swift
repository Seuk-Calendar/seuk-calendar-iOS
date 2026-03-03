import Foundation

public enum TimeOffset {
  case day(Int)
  case hour(Int)
  case min(Int)

  var seconds: TimeInterval {
    switch self {
    case let .day(value):
      Double(value) * 86400
    case let .hour(value):
      Double(value) * 3600
    case let .min(value):
      Double(value) * 60
    }
  }
}

public extension Date {
  func after(_ offset: TimeOffset) -> Date {
    addingTimeInterval(offset.seconds)
  }

  func before(_ offset: TimeOffset) -> Date {
    addingTimeInterval(-offset.seconds)
  }
}
