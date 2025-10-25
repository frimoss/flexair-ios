//
//  SecondaryButtonStyle.swift
//  flexair
//
//  Created by Nikolai on 25/10/2025.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Styles
            .padding(.horizontal)
            .frame(height: Constants.UI.height)
            .background(Constants.Colors.background)
            .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
            
            // Hover Effect
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
