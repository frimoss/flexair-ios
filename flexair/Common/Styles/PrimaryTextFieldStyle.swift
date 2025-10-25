//
//  PrimaryTextFieldStyle.swift
//  flexair
//
//  Created by Nikolai on 24/10/2025.
//

import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(.horizontal) // Internal padding
            .frame(height: Constants.UI.height)
            .foregroundStyle(Constants.Colors.textPrimary)
            .background(Constants.Colors.background)
            .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
    }
}
