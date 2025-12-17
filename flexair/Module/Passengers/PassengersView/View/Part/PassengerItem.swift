//
//  PassengerItem.swift
//  flexair
//
//  Created by Nikolai on 02/12/2025.
//

import SwiftUI

struct PassengerItem: View {
    
    var passenger: Passenger
    var isSelected: Bool = false
    var selectPassenger: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                selectPassenger()
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(Constants.Colors.accent)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(passenger.fullName)
                            .font(.system(size: 15, weight: .medium))
                        
                        Text(passenger.dob)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Constants.Colors.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 20)
                .padding(.leading, 20)
            }
        
            if isSelected {
                NavigationLink {
                    AddPassengerView(passenger: passenger)
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 18))
                        .padding(4)
                        .foregroundStyle(Constants.Colors.accentApple)
                }
                .padding(.trailing, 20)
            }
        }
        .foregroundStyle(Constants.Colors.textPrimary)
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(Constants.Colors.accentApple.opacity(0.7), lineWidth: isSelected ? 2 : 0)
                .fill(Constants.Colors.background)
        )
        .padding(2)
    }
}
