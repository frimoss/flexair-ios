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
                            .font(.system(size: 13, weight: .regular))
                        
                        Text(userInput)
                            .foregroundStyle(Constants.Colors.textPrimary)
                            .font(.system(size: 15, weight: .medium))
                    } else {
                        Text(title)
                            .foregroundStyle(isPrimaryColor ? Constants.Colors.textPrimary : Constants.Colors.textSecondary)
                            .font(.system(size: 14, weight: .medium))
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(SecondaryButtonStyle())
    }
}
