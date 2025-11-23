//
//  FlightSearchViewModel.swift
//  flexair
//
//  Created by Nikolai on 23/11/2025.
//

import Foundation

protocol FlightSearchViewModelProtocol {
    func searchFlights() async
    func clearResults()
}

@Observable
final class FlightSearchViewModel: FlightSearchViewModelProtocol {
    // State
    var flights: [Flight] = []
    var isLoading = false
    var errorMessage: String?
    
    // Search filters
    var origin = ""
    var destination = ""
    var departureDate = ""
    
    private let flightService = FlightService()
    
    // MARK: - Search Flights
    func searchFlights() async {
        errorMessage = nil
        isLoading = true
        
        do {
            flights = try await flightService.searchFlights(
                origin: origin,
                destination: destination,
                departureDate: departureDate)
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
            flights = []
        } catch {
            errorMessage = "Search Failed"
            flights = []
        }
        
        isLoading = false
    }
    
    // MARK: - Clear Results
    func clearResults() {
        flights = []
        errorMessage = nil
        origin = ""
        destination = ""
        departureDate = ""
    }
}
