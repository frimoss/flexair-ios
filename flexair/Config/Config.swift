//
//  Config.swift
//  flexair
//
//  Created by Nikolai on 21/12/2025.
//

import Foundation

enum Config {
    // MARK: - Supabase
    static var supabaseURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String else {
            fatalError("SUPABASE_URL not found in Info.plist")
        }
        return url
    }
    
    static var supabaseKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String else {
            fatalError("SUPABASE_KEY not found in Info.plist")
        }
        return key
    }
}
