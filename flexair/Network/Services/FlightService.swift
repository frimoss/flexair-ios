//
//  FlightService.swift
//  flexair
//
//  Created by Nikolai on 30/11/2025.
//

import Foundation

final class FlightService {
    private let supabase = SupabaseManager.shared.supabase
    
    // MARK: Fetch All Airports
    /// Fetches all available airports
    func fetchAirports() async throws -> [Airport] {
        let airports: [Airport] = try await supabase
          .from("airports")
          .select()
          .execute()
          .value
        
        return airports
    }
    
    // MARK: Search Flights
    /// Searches for flights matching the criteria
    func searchFlights(
        originAirportCode: String,
        destinationAirportCode: String,
        departureDate: Date
    ) async throws -> [Flight] {
        
        // Convert Date to String format for Database
        let departureDateString = "2025-12-15"//departureDate.toDateString() // MARK: Date for Test
        
        let flights: [Flight] = try await supabase
            .rpc(
                "search_flights",
                params: [
                    "p_departure_airport_code": originAirportCode,
                    "p_arrival_airport_code": destinationAirportCode,
                    "p_departure_date": departureDateString
                ]
            )
            .execute()
            .value
        
        return flights
    }
}
