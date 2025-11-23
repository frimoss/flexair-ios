//
//  Flight.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

struct Flight: Identifiable, Decodable {
    let id: Int
    let flightNumber: String
    let originCode: String
    let originName: String
    let destinationCode: String
    let destinationName: String
    let departureTime: Date
    let arrivalTime: Date
    let price: Double
    let availableSeats: Int
    let airline: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case flightNumber = "flight_number"
        case originCode = "origin_code"
        case originName = "origin_name"
        case destinationCode = "destination_code"
        case destinationName = "destination_name"
        case departureTime = "departure_time"
        case arrivalTime = "arrival_time"
        case price
        case availableSeats = "available_seats"
        case airline
    }
}
