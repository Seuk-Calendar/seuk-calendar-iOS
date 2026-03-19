enum Platform {
  static var isMac: Bool {
    #if os(macOS)
      true
    #else
      false
    #endif
  }
}
