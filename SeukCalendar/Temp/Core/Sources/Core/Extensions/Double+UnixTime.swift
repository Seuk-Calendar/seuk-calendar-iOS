import Foundation

public extension Double {
    var unixTimeToDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: self)))
    }
}
