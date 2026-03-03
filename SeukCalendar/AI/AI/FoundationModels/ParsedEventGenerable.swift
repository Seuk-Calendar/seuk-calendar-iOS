#if canImport(FoundationModels)
  import FoundationModels

  @available(iOS 26.0, macOS 26.0, *)
  @Generable
  struct ParsedEventGenerable {
    let title: String
    let dateString: String
    let startTime: String?
    let durationMinutes: Int?
    let location: String?
    let notes: String?
    let isAllDay: Bool
  }
#endif
