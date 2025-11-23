//
//  RegisterRequest.swift
//  flexair
//
//  Created by Nikolai on 22/11/2025.
//

import Foundation

struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
