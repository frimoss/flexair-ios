//
//  String+Extension.swift
//  flexair
//
//  Created by Nikolai on 08/12/2025.
//

import Foundation

extension String {
    // MARK: String "yyy-MM-dd" to String "dd.MM.yyyy"
    func toDayMonthYear() -> String {
        // 1. Parse ISO date
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate]

        guard let date = isoFormatter.date(from: self) else {
            return self // return original if parsing fails
        }

        // 2. Output format
        let output = DateFormatter()
        output.locale = Locale(identifier: "en_US_POSIX")
        output.dateFormat = "dd.MM.yyyy"

        return output.string(from: date)
    }
    
    // MARK: - to "Wed, 15 Dec" and "10:30"
    func toFormattedDate() -> (date: String, time: String)? {
        // Parse the string to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        // Format date: "Wed, 15 Dec"
        let dateOutputFormatter = DateFormatter()
        dateOutputFormatter.dateFormat = "EEE, dd MMM"
        dateOutputFormatter.locale = Locale(identifier: "en_US")
        dateOutputFormatter.timeZone = TimeZone(identifier: "UTC")
        
        // Format time: "10:30"
        let timeOutputFormatter = DateFormatter()
        timeOutputFormatter.dateFormat = "HH:mm"
        timeOutputFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return (
            date: dateOutputFormatter.string(from: date),
            time: timeOutputFormatter.string(from: date)
        )
    }
    
    // MARK: - To string "15 December" or "1 January 2026"
    func formatToFullDate() -> String? {
        // 1. Parse input string into Date
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // safely parse Z / UTC
        
        guard let date = inputFormatter.date(from: self) else {
            return nil
        }
        
        // 2. Compare years
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let dateYear = calendar.component(.year, from: date)
        
        // 3. Prepare output formatter
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = .current
        
        if dateYear == currentYear {
            outputFormatter.dateFormat = "d MMMM"          // 15 December
        } else {
            outputFormatter.dateFormat = "d MMMM yyyy"     // 1 January 2026
        }
        
        return outputFormatter.string(from: date)
    }
    
    // MARK: - Calc Duration of Flight
    func flightDurationFromFull(to arrivalTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        guard let departure = formatter.date(from: self),
              let arrival = formatter.date(from: arrivalTime) else {
            return "N/A"
        }
        
        let duration = arrival.timeIntervalSince(departure)
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if minutes == 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(minutes)m"
        }
    }
}
