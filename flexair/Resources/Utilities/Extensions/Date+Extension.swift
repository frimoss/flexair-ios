//
//  Date+Extension.swift
//  flexair
//
//  Created by Nikolai on 23/11/2025.
//

import Foundation

extension Date {
    // MARK: - to API String format "yyyy-MM-dd"
    /// Convert Date to "2025-11-23" format for API Supabase "yyyy-MM-dd" string format
    func toAPIFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: self)
    }
    
    // MARK: - To string "22 Nov, Sat"
    func toDayMonthWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, EEE"   // "22 Nov, Sat"
        return formatter.string(from: self)
    }
}
