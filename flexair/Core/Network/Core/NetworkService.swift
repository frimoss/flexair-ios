//
//  NetworkService.swift
//  flexair
//
//  Created by Nikolai on 22/10/2025.
//

import Foundation

class NetworkService {
    // Create "Singleton" = Only ONE NetworkService for entire app (Saves Main Memory)
    static let shared = NetworkService()
    private init() {}
    
    // MARK: User's Access Token (After Log In)
    var accessToken: String?
    
    // MARK: - MAIN Request func (Send Request, Get Response)
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        body: Encodable? = nil
    ) async throws -> T {
        
        // Check Valid URL
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        // MARK: - Create the Request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add "Access Token" if User is Logged In
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // If we're sending data (POST), pack it into JSON
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        // MARK: - Send request and wait for response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        // Handle different Response Codes
        switch httpResponse.statusCode {
        case 200...299:
            // ✅ Success! Decode the data
            do {
                let decoder = JSONDecoder()
                
                //decoder.dateDecodingStrategy = .iso8601 // For Dates like "2025-11-22" (with Time Zone)
                // MARK: - DateFormatter (remove Time Zone) - Backend stores dates without time zone
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    
                    /// DateFormatter for "2025-11-25T10:00:00" (NO TimeZone)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.timeZone = TimeZone(secondsFromGMT: 0) // Treat as UTC
                    
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                    
                    throw DecodingError.dataCorruptedError(
                        in: container,
                        debugDescription: "Cannot decode date: \(dateString)"
                    )
                }
                
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding Error: \(error)")
                throw NetworkError.decodingFailed
            }
            
        case 401:
            // Token Expired or Not Logged In
            throw NetworkError.unauthorized
        
        case 500...599:
            // Backend is broken
            throw NetworkError.serverError(httpResponse.statusCode)
            
        default:
            // Unknown Error
            throw NetworkError.unknown(NSError(domain: "", code: httpResponse.statusCode))
            
        }
    }
    
    // MARK: - Login Request (Send Request, Get Response)
    func loginRequest(username: String, password: String) async throws -> LoginResponse {
        
        // Check Valid URL
        guard let url = APIEndpoint.login.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = "grant_type=password&username=\(username)&password=\(password)"
        request.httpBody = bodyString.data(using: .utf8)
        
        // MARK: Send request and wait for response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            // ✅ Success! Decode the data
            let decoder = JSONDecoder()
            let loginResponse = try decoder.decode(LoginResponse.self, from: data)
            
            // Save Token for future requests
            self.accessToken = loginResponse.accessToken
            
            return loginResponse
            
        case 401:
            // Token Expired or Not Logged In
            throw NetworkError.unauthorized
            
        default:
            // Unknown Error
            throw NetworkError.serverError(httpResponse.statusCode)
            
        }
    }
}
