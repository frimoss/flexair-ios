//
//  FlightService.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

// MARK: Search Flights

class FlightService {
    
    private let network = NetworkService.shared
    
    // MARK: - Search Flights
    func searchFlights(
        origin: String? = nil,
        destination: String? = nil,
        departureDate: String? = nil
    ) async throws -> [Flight] {
        return try await network.request(
            endpoint: .searchFlights(
                origin: origin,
                destination: destination,
                date: departureDate
            )
        )
    }
}
