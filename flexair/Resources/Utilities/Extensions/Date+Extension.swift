//
//  Date+Extension.swift
//  flexair
//
//  Created by Nikolai on 23/11/2025.
//

import Foundation

extension Date {
    /// Convert Date to "2025-11-23" format for API
    func toAPIFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
}
