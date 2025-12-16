//
//  AppError.swift
//  flexair
//
//  Created by Nikolai on 30/11/2025.
//

import Foundation

enum AppError: LocalizedError {
    case notAuthenticated
    case invalidResponse
    case bookingFailed(String)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Please sign in to continue"
        case .invalidResponse:
            return "Something went wrong. Please try again"
        case .bookingFailed(let reason):
            return "Booking failed: \(reason)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
