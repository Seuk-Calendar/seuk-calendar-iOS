//
//  PLDateComponentsFormatter+make.swift
//  Core
//
//  Created by yongbeomkwak on 2/17/26.
//

import Foundation

public enum PLDateComponentsFormat: PLFormatType {
  /// mm:ss
  case playerTime
}

extension PLFormatter.PLDateComponentsFormatter: PLFormattable {
  static func make(_ format: PLDateComponentsFormat) -> DateComponentsFormatter {
    let formatter = DateComponentsFormatter()

    switch format {
    case .playerTime:
      formatter.allowedUnits = [.minute, .second] // 표시할 단위
      formatter.unitsStyle = .positional // 00:00 형식
      formatter.zeroFormattingBehavior = .pad // 한 자리 숫자일 때 앞에 0을 채움
    }

    return formatter
  }
}
