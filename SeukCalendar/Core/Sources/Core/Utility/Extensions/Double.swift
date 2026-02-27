//
//  Double+UnixTimeToDate.swift
//  Core
//
//  Created by yongbeomkwak on 10/7/25.
//

import Foundation

public extension Double {
    var unixTimeToDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: self)))
    }
}
