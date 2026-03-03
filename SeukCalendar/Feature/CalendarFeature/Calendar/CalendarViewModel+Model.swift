public extension CalendarViewModel {
  enum ViewMode: String, CaseIterable, Identifiable {
    case month
    case week
    case day

    public var id: String { rawValue }

    public var title: String {
      switch self {
      case .month:
        "월"
      case .week:
        "주"
      case .day:
        "일"
      }
    }
  }

  enum PermissionState: Equatable {
    case idle
    case granted
    case denied(String)

    public var isDenied: Bool {
      if case .denied = self {
        return true
      }

      return false
    }
  }
}
