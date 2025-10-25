//
//  SearchFlightButtonView.swift
//  flexair
//
//  Created by Nikolai on 25/10/2025.
//

import SwiftUI

struct SearchFlightButtonView: View {
    var title: String
    var userInput: String = ""
    var image: String = ""
    var isPrimaryColor: Bool = false
    
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center) {
                if !image.isEmpty {
                    Image(image)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    if !userInput.isEmpty {
                        Text(title)
                            .foregroundStyle(Constants.Colors.textSecondary)
                            .font(.custom(Constants.Fonts.regular, size: 12))
                        
                        Text(userInput)
                            .foregroundStyle(Constants.Colors.textPrimary)
                            .font(.custom(Constants.Fonts.medium, size: 14))
                    } else {
                        Text(title)
                            .foregroundStyle(isPrimaryColor ? Constants.Colors.textPrimary : Constants.Colors.textSecondary)
                            .font(.custom(Constants.Fonts.medium, size: 14))
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(SecondaryButtonStyle())
    }
}
