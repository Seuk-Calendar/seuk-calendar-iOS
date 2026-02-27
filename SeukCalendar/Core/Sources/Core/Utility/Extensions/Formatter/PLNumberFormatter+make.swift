//
//  PLNumberFormatter+make.swift
//  Core
//
//  Created by yongbeomkwak on 2/8/26.
//

import Foundation

public enum PLNumberFormat: PLFormatType {
  case decimal
}

extension PLFormatter.PLNumberFormatter: PLFormattable {
  static func make(_ format: PLNumberFormat) -> NumberFormatter {
    let numberFormatter = NumberFormatter()

    switch format {
    case .decimal:
      numberFormatter.numberStyle = .decimal
    }

    return numberFormatter
  }
}
