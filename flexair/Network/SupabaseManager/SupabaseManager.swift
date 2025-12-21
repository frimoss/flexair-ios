//
//  SupabaseManager.swift
//  flexair
//
//  Created by Nikolai on 25/11/2025.
//

import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager() // MARK: Singleton Design Pattern (one DB connection)
    
    let supabase: SupabaseClient
    
    private init() {
        guard let url = URL(string: Config.supabaseURL) else {
            fatalError("Invalid Supabase URL")
        }
        
        self.supabase = SupabaseClient(
            supabaseURL: url,
            supabaseKey: Config.supabaseKey
        )
    }
}
