//
//  BookingRequest.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

struct BookingRequest: Encodable {
    let flightId: Int
    let passengerName: String
    
    enum CodingKeys: String, CodingKey {
        case flightId = "flight_id"
        case passengerName = "passenger_name"
    }
}
