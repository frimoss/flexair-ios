//
//  PrimaryButtonStyle.swift
//  flexair
//
//  Created by Nikolai on 25/10/2025.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Font Size
            .font(.system(size: 18, weight: .regular))
        
            // Styles
            .frame(maxWidth: .infinity)
            .frame(height: Constants.UI.height)
        
            .foregroundStyle(Constants.Colors.textAccent)
            .background(Constants.Colors.accent)
            
            .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
        
            // Hover Effect
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        
            // Disabled
            .opacity(
                isEnabled ? 1 : 0.8
            )
    }
}
