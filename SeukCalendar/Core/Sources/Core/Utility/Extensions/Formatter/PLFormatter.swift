//
//  PLFormatter.swift
//  Core
//
//  Created by yongbeomkwak on 2/7/26.
//

import Foundation

protocol PLFormatType {}

protocol PLFormattable {
  associatedtype FormatType: PLFormatType
  associatedtype Result: Formatter // 반환할 구체적인 타입 (DateFormatter 등)

  static func make(_ format: FormatType) -> Result
}

public enum PLFormatter {
  public enum PLDateFormatter {
    /// yyyy-MM-dd
    public static let dateFormatter = PLDateFormatter.make(.date)
    /// yyyy-MM-dd HH:mm
    public static let withoutSecondFormatter = PLDateFormatter.make(.withoutSecond)
    /// yyyy-MM-dd HH:mm:ss
    public static let dateTimeFormatter = PLDateFormatter.make(.dateTime)
  }

  public enum PLNumberFormatter {
    public static let decimalFormatter = PLNumberFormatter.make(.decimal)
  }

  public enum PLDateComponentsFormatter {
    /// 영상 시간 표시용
    public static let playerTimeFormatter = PLDateComponentsFormatter.make(.playerTime)
  }
}
