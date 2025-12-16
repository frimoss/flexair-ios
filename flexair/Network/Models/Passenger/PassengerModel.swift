//
//  PassengerModel.swift
//  flexair
//
//  Created by Nikolai on 28/11/2025.
//

import Foundation

struct Passenger: Codable, Identifiable {
    let passengerId: Int
    let userId: UUID
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let gender: String
    let nationality: String
    let createdAt: String
    
    // To use ForEach
    var id: Int { passengerId }
    var fullName: String { "\(firstName) \(lastName)" }
    var dob: String { dateOfBirth.toDayMonthYear() } // To "dd.MM.yyyy"
    
    enum CodingKeys: String, CodingKey {
        case passengerId = "passenger_id"
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case gender
        case nationality
        case createdAt = "created_at"
    }
}
