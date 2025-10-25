//
//  Constants.swift
//  flexair
//
//  Created by Nikolai on 24/10/2025.
//

import SwiftUI

enum Constants {
    
    enum API {
        static let baseURL = ""
        static let timeout: TimeInterval = 0.0
    }
    
    enum UI {
        /// Custom Radius = 20
        static let cornerRadius: CGFloat = 20
        /// Default Height = 70
        static let height: CGFloat = 64
        
        static let defaultPadding: CGFloat = 16 // EXAMPLE
    }
    
    enum Colors {
        /// Main Yellow
        static let accent = Color("AccentColor")
        static let textAccent = Color("TextAccent")
        
        /// TextPrimary: White
        static let textPrimary = Color("TextPrimary")
        /// TextSecondary: Gray
        static let textSecondary = Color("TextSecondary")
        
        static let background = Color("Background")
    }
    
    enum Fonts {
        static let light = "NeueMontreal-Light"
        static let regular = "NeueMontreal-Regular"
        static let medium = "NeueMontreal-Medium"
        static let bold = "NeueMontreal-Bold"
    }
    
    enum UserDefaultsKeys {
        static let isLoggedIn = "isLoggedIn"
        static let token = "authToken"
    }
}
