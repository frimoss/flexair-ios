//
//  AirportModel.swift
//  flexair
//
//  Created by user on 21/11/2025.
//

import Foundation

struct Airport: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let code: String
    let city: String
    let country: String
    
    var displayName: String {
        "\(city) (\(code))"
    }
    
    var fullName: String {
        "\(name), \(city), \(country)"
    }
}

let airportData: [Airport] = [
    Airport(id: 1, name: "Istanbul Airport", code: "IST", city: "Istanbul", country: "Turkey"),
    Airport(id: 2, name: "Sabiha Gökçen Airport", code: "SAW", city: "Istanbul", country: "Turkey"),
    Airport(id: 3, name: "John F. Kennedy", code: "JFK", city: "New York", country: "US"),
    Airport(id: 4, name: "Los Angeles Airport", code: "LAX", city: "Los Angeles", country: "US"),
    Airport(id: 5, name: "Heathrow Airport", code: "LHR", city: "London", country: "UK"),
    Airport(id: 6, name: "Domodedovo", code: "DME", city: "Moscow", country: "Russia"),
    Airport(id: 7, name: "Dubai Airport", code: "DXB", city: "Dubai", country: "UAE"),
    Airport(id: 8, name: "Haneda Airport", code: "HND", city: "Tokyo", country: "Japan"),
    Airport(id: 9, name: "Amsterdam Airport", code: "AMS", city: "Amsterdam", country: "Netherlands"),
    Airport(id: 10, name: "Charles de Gaulle Airport", code: "CDG", city: "Paris", country: "France"),
    Airport(id: 11, name: "Frankfurt Airport", code: "FRA", city: "Frankfurt", country: "Germany")
]
