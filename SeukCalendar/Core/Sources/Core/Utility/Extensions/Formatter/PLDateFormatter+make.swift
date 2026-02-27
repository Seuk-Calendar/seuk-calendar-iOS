//
//  PLDateFormatter.swift
//  Core
//
//  Created by yongbeomkwak on 12/3/25.
//

import Foundation

public enum PLDateFormat: PLFormatType {
  /// yyyy-MM-dd
  case date
  /// yyyy-MM-dd HH:mm
  case withoutSecond
  /// yyyy-MM-dd HH:mm:ss
  case dateTime

  var formatString: String {
    switch self {
    case .date:
      return "yyyy-MM-dd"
    case .withoutSecond:
      return "yyyy-MM-dd HH:mm"
    case .dateTime:
      return "yyyy-MM-dd HH:mm:ss"
    }
  }
}

extension PLFormatter.PLDateFormatter: PLFormattable {
  static func make(_ format: PLDateFormat) -> DateFormatter {
    let formatter = DateFormatter()
     formatter.dateFormat = format.formatString
     return formatter
  }
}
