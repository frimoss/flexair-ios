//
//  NetworkError.swift
//  flexair
//
//  Created by Nikolai on 22/10/2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case unauthorized
    case serverError(Int) // Backend is broken (500, 503, etc.)
    case unknown(Error) // Something weird happened ;c
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data received from server"
        case .decodingFailed:
            return "Failed to decode server response"
        case .unauthorized:
            return "Please Log in again"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
