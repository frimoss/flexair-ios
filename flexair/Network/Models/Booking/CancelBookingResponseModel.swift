//
//  CancelBookingResponse.swift
//  flexair
//
//  Created by Nikolai on 27/11/2025.
//

import Foundation

struct CancelBookingResponse: Codable {
    let bookingId: Int
    let status: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case status
        case success
    }
}
