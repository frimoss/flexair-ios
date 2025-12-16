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
        self.supabase = SupabaseClient(
            supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
            supabaseKey: "YOUR_SUPABASE_KEY"
        )
    }
}
