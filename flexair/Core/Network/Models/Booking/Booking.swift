//
//  Booking.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

struct Booking: Identifiable, Decodable {
    let id: Int
    let bookingReference: String
    let flightNumber: String
    let passengerName: String
    let totalPrice: Double
    let status: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case bookingReference = "booking_reference"
        case flightNumber = "flight_number"
        case passengerName = "passenger_name"
        case totalPrice = "total_price"
        case status
        case createdAt = "created_at"
    }
}
