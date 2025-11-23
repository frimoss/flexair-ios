//
//  APIEndpoint.swift
//  flexair
//
//  Created by Nikolai on 22/10/2025.
//

import Foundation

enum APIEndpoint {
    case register
    case login
    case searchFlights(origin: String?, destination: String?, date: String?)
    case createBooking
    case userBooking
    
    private var baseURL: String {
        return "http://192.168.1.48:8080"
    }
    
    var url: URL? {
        switch self {
        case .register:
            return URL(string: "\(baseURL)/auth/register")
            
        case .login:
            return URL(string: "\(baseURL)/auth/login")
            
        case .searchFlights(let origin, let destination, let date):
            var components = URLComponents(string: "\(baseURL)/api/flights/search")
            var queryItems: [URLQueryItem] = []
            
            if let origin = origin {
                queryItems.append(URLQueryItem(name: "origin", value: origin))
            }
            if let destination = destination {
                queryItems.append(URLQueryItem(name: "destination", value: destination))
            }
            if let date = date {
                queryItems.append(URLQueryItem(name: "departure_date", value: date))
            }
            
            components?.queryItems = queryItems.isEmpty ? nil : queryItems
            
            return components?.url
            
        case .createBooking:
            return URL(string: "\(baseURL)/api/bookings")
        case .userBooking:
            return URL(string: "\(baseURL)/api/bookings/user")
        }
    }
    
    var httpMethod: String {
        switch self {
        case .register, .login, .createBooking:
            return "POST"
        case .searchFlights, .userBooking:
            return "GET"
            
        }
    }
    
}
