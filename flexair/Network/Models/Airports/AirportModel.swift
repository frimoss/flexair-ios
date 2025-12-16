//
//  AirportModel.swift
//  flexair
//
//  Created by Nikolai on 21/11/2025.
//

import Foundation

struct Airport: Codable, Identifiable {
    let airportId: Int
    let airportCode: String
    let airportName: String
    let city: String
    let country: String
    
    // To use ForEach
    var id: Int { airportId }
    
    enum CodingKeys: String, CodingKey {
        case airportId = "airport_id"
        case airportCode = "airport_code"
        case airportName = "airport_name"
        case city
        case country
    }
    
    var displayName: String {
        "\(city), \(airportCode)"
    }
    
    var fullName: String {
        "\(airportName), \(airportCode)"
    }
}

let airportData: [Airport] = [
    Airport(airportId: 1, airportCode: "IST", airportName: "Istanbul Airport", city: "Istanbul", country: "Turkey")
]
