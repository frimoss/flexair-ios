//
//  UserBooking.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

struct UserBooking: Codable, Identifiable, Hashable {
    let bookingId: Int
    let bookingReference: String
    let bookingDate: String // Fix: from Date
    let status: String
    let totalPrice: Decimal
    let flightId: Int
    let flightNumber: String
    let airlineName: String
    let departureAirportCode: String
    let departureAirportName: String
    let departureCity: String
    let arrivalAirportCode: String
    let arrivalAirportName: String
    let arrivalCity: String
    let departureTime: String // Fix: from Date
    let arrivalTime: String // Fix: from Date
    let passengerId: Int
    let passengerFirstName: String
    let passengerLastName: String
    let dateOfBirth: String // Fix: from Date
    
    var id: Int { bookingId }
    var route: String { "\(departureCity) – \(arrivalCity)" }
    var fullDepartureDate: String { departureTime.formatToFullDate() ?? "" }
    
    var departureAirportTitle: String { "\(departureAirportName), \(departureAirportCode)" }
    var arrivalAirportTitle: String { "\(arrivalAirportName), \(arrivalAirportCode)" }
    
    var formattedDepartureDate: String { departureTime.toFormattedDate()?.date ?? "N/A" }
    var formattedDepartureTime: String { departureTime.toFormattedDate()?.time ?? "N/A" }
    
    var formattedArrivalDate: String { arrivalTime.toFormattedDate()?.date ?? "N/A" }
    var formattedArrivalTime: String { arrivalTime.toFormattedDate()?.time ?? "N/A" }
    
    var passengerFullName: String { "\(passengerFirstName) \(passengerLastName)" }
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
        case bookingReference = "booking_reference"
        case bookingDate = "booking_date"
        case status
        case totalPrice = "total_price"
        case flightId = "flight_id"
        case flightNumber = "flight_number"
        case airlineName = "airline_name"
        case departureAirportCode = "departure_airport_code"
        case departureAirportName = "departure_airport_name"
        case departureCity = "departure_city"
        case arrivalAirportCode = "arrival_airport_code"
        case arrivalAirportName = "arrival_airport_name"
        case arrivalCity = "arrival_city"
        case departureTime = "departure_time"
        case arrivalTime = "arrival_time"
        case passengerId = "passenger_id"
        case passengerFirstName = "passenger_first_name"
        case passengerLastName = "passenger_last_name"
        case dateOfBirth = "date_of_birth"
    }
}
