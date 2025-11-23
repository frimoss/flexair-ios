//
//  AuthService.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

// MARK: Login/Register/Logout

class AuthService {
    
    private let network = NetworkService.shared
    
    // MARK: - Register new user
    func register(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws {
        let request = RegisterRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName)
        
        // Empty Response (because Backend doesn't return data on Register)
        struct EmptyResponse: Decodable {}
        let _: EmptyResponse = try await network.request(
            endpoint: .register,
            body: request
        )
    }
    
    // MARK: - Login user (Email, Password)
    func login(email: String, password: String) async throws -> LoginResponse {
        return try await network.loginRequest(username: email, password: password)
    }
    
    // MARK: - Logout
    func logout() {
        network.accessToken = nil // (just clear User's Token)
    }
}

