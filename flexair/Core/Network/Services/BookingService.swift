//
//  BookingService.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

// MARK: Create Booking / Get User Bookings

class BookingService {
    
    private let network = NetworkService.shared
    
    // MARK: - Create New Booking
    func createBooking(flightId: Int, passengerName: String) async throws -> Booking {
        let request = BookingRequest(flightId: flightId, passengerName: passengerName)
        
        return try await network.request(
            endpoint: .createBooking,
            body: request
        )
    }
    
    // MARK: - Get All User's Bookings
    func getUserBookings() async throws -> [Booking] {
        return try await network.request(endpoint: .userBooking)
    }
}
