//
//  FlightModel.swift
//  flexair
//
//  Created by Nikolai on 26/11/2025.
//

import Foundation

struct Flight: Codable, Identifiable, Hashable {
    let flightId: Int
    let flightNumber: String
    let airlineName: String
    let airlineCode: String
    let departureAirportCode: String
    let departureAirportName: String
    let departureCity: String
    let arrivalAirportCode: String
    let arrivalAirportName: String
    let arrivalCity: String
    let departureTime: String
    let arrivalTime: String
    let price: Decimal
    let availableSeats: Int
    let status: String
    
    // To use ForEach
    var id: Int { flightId }
    
    // Helper properties for UI
    var departureAirportTitle: String { "\(departureAirportName), \(departureAirportCode)" }
    var arrivalAirportTitle: String { "\(arrivalAirportName), \(arrivalAirportCode)" }
    
    var formattedDepartureTime: String { departureTime.toFormattedDate()?.time ?? "N/A" }
    var formattedDepartureDate: String { departureTime.toFormattedDate()?.date ?? "N/A" }
    
    var formattedArrivalTime: String { arrivalTime.toFormattedDate()?.time ?? "N/A" }
    var formattedArrivalDate: String { arrivalTime.toFormattedDate()?.date ?? "N/A" }
    
    var duration: String { departureTime.flightDurationFromFull(to: arrivalTime) }
    
    var route: String { "\(departureCity) – \(arrivalCity)" }
    
    var flightPrice: Int { price.intValue }
    var baggagePrice: Int { (price * 0.15).intValue }
    var refundPrice: Int { (price * 0.12).intValue }
        
    enum CodingKeys: String, CodingKey {
        case flightId = "flight_id"
        case flightNumber = "flight_number"
        case airlineName = "airline_name"
        case airlineCode = "airline_code"
        case departureAirportCode = "departure_airport_code"
        case departureAirportName = "departure_airport_name"
        case departureCity = "departure_city"
        case arrivalAirportCode = "arrival_airport_code"
        case arrivalAirportName = "arrival_airport_name"
        case arrivalCity = "arrival_city"
        case departureTime = "departure_time"
        case arrivalTime = "arrival_time"
        case price
        case availableSeats = "available_seats"
        case status
    }
}
