//
//  ArrowButtonStyle.swift
//  flexair
//
//  Created by Nikolai on 25/10/2025.
//

import SwiftUI

struct ArrowButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(Constants.Colors.accent)
            .padding(12)
            .background(Constants.Colors.background)
            .clipShape(Circle())
            .shadow(radius: 12)
        
            // Hover Effect
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
