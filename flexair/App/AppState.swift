//
//  AppState.swift
//  flexair
//
//  Created by Nikolai on 11/12/2025.
//

import Foundation

@Observable
final class AppState {
    
    enum State {
        case loading
        case authenticated
        case unauthenticated
    }
    
    private(set) var state: State = .loading
    private let authService = AuthService.shared
    
    func initialize() async {
        let startTime = Date()
        
        // Load app data
        await authService.checkSession()
        
        // Ensure minimum 3 seconds
        let elapsed = Date().timeIntervalSince(startTime)
        if elapsed < 0.7 {
            try? await Task.sleep(nanoseconds: UInt64((0.7 - elapsed) * 1_000_000_000))
        }
        
        // Update state
        state = authService.isAuthenticated ? .authenticated : .unauthenticated
    }
}
