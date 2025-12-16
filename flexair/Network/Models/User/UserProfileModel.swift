//
//  UserProfile.swift
//  flexair
//
//  Created by Nikolai on 27/11/2025.
//

import Foundation

struct UserProfile: Codable, Identifiable {
    let id: UUID
    let email: String?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
    }
}
