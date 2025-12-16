//
//  BookingService.swift
//  flexair
//
//  Created by Nikolai on 30/11/2025.
//

import Foundation

final class BookingService {
    private let supabase = SupabaseManager.shared.supabase
    
    // MARK: Create Booking
    /// Creates a new booking for a passenger on a flight
    func createBooking(
        userId: UUID,
        flightId: Int,
        passengerId: Int,
        totalPrice: Int
    ) async throws -> UserBooking {
        
        struct CreateBookingParams: Encodable {
            let p_user_id: String
            let p_flight_id: Int
            let p_passenger_id: Int
            let p_total_price: Decimal
        }
        
        let params = CreateBookingParams(
            p_user_id: userId.uuidString,
            p_flight_id: flightId,
            p_passenger_id: passengerId,
            p_total_price: Decimal(totalPrice)
        )
        
        let bookings: [UserBooking] = try await supabase
            .rpc("create_booking", params: params)
            .execute()
            .value
        
        guard let booking = bookings.first else {
            throw NSError(domain: "FlightBooking", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to create booking"])
        }
        
        return booking
    }
    
    // MARK: Fetch User Bookings
    /// Fetches all bookings for a user
    func getUserBookings(userId: UUID) async throws -> [UserBooking] {
        let bookings: [UserBooking] = try await supabase
            .rpc(
                "get_user_bookings",
                params: ["p_user_id": userId.uuidString]
            )
            .execute()
            .value
        
        return bookings
    }
    
    // MARK: Cancel Booking
    /// Cancels an existing booking
    func cancelBooking(bookingId: Int, userId: UUID) async throws -> CancelBookingResponse {
        
        struct CancelBookingParams: Encodable {
            let p_booking_id: Int
            let p_user_id: String
        }
        
        let params = CancelBookingParams(
            p_booking_id: bookingId,
            p_user_id: userId.uuidString
        )
        
        let responses: [CancelBookingResponse] = try await supabase
            .rpc("cancel_booking",params: params)
            .execute()
            .value
        
        print("Responses: \(responses)")
        
        guard let response = responses.first else {
            throw NSError(domain: "FlightBooking", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to cancel booking"])
        }
        
        return response
    }
}
