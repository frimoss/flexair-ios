//
//  flexairApp.swift
//  flexair
//
//  Created by Nikolai on 21/10/2025.
//

import SwiftUI

@main
struct flexairApp: App {
    
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appState.state {
                case .loading:
                    LoadView()
                        .transition(.opacity)
                
                case .authenticated:
                    MainTabView()
                        .transition(.opacity)
                
                case .unauthenticated:
                    LoginView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: appState.state)
            .preferredColorScheme(.dark)
            .task {
                await appState.initialize()
            }
        }
    }
}
