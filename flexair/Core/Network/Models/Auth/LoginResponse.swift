//
//  LoginResponse.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

struct LoginResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
