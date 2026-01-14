//
//  FlightSearchViewModel.swift
//  flexair
//
//  Created by Nikolai on 27/11/2025.
//

import Foundation

@Observable
final class FlightSearchViewModel {
    
    // MARK: - Dependencies
    private let flightService: FlightService
    
    // MARK: - State
    private(set) var airports: [Airport] = []
    private(set) var flights: [Flight] = []
    
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Initialization
    init(flightService: FlightService = FlightService()) {
        self.flightService = flightService
    }
    
    // MARK: - Public Methods
    
    // MARK: Fetch All Airports
    /// Loads all available airports
    func loadAirports() async {
        errorMessage = nil
        
        do {
            airports = try await flightService.fetchAirports()
            print("✅ Loaded \(airports.count) airports")
        } catch {
            errorMessage = "Failed to load airports"
            print("❌ Airport loading failed: \(error)")
        }
    }
    
    // MARK: Search Flights
    /// Searches for flights matching criteria
    func searchFlights(
        originCode: String,
        destinationCode: String,
        departureDate: Date
    ) async {
        errorMessage = nil
        isLoading = true
        
        // MARK: - TODO? originCode != destinationCode 
        
        do {
            flights = try await flightService.searchFlights(
                originAirportCode: originCode,
                destinationAirportCode: destinationCode,
                departureDate: departureDate
            )
            
            if flights.isEmpty {
                errorMessage = "No flights found for this route"
            }
            
            print("✅ Found \(flights.count) flights")
        } catch {
            errorMessage = "Search failed. Please try again"
            print("❌ Flight search failed: \(error)")
        }
        
        isLoading = false
    }
}
