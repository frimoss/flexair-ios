//
//  Constants.swift
//  flexair
//
//  Created by Nikolai on 24/10/2025.
//

import SwiftUI

enum Constants {
    
    enum UI {
        /// Custom Radius = 20
        static let cornerRadius: CGFloat = 20
        /// Default Height = 70
        static let height: CGFloat = 64
        
        static let defaultPadding: CGFloat = 16 // EXAMPLE
    }
    
    enum Colors {
        /// Main Yellow
        static let accentApple = Color("AccentColor")
        static let accent = Color("MyAccentColor")
        static let textAccent = Color("TextAccent")
        
        /// TextPrimary: White
        static let textPrimary = Color("TextPrimary")
        /// TextSecondary: Gray
        static let textSecondary = Color("TextSecondary")
        
        static let background = Color("Background")
        static let backgroundLight = Color("BackgroundLight")
        static let backgroundApp = Color("BackgroundApp")
    }
    
    enum UserDefaultsKeys {
        static let isLoggedIn = "isLoggedIn"
        static let token = "authToken"
    }
}
