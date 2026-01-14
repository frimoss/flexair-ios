//
//  FlightListView.swift
//  flexair
//
//  Created by Nikolai on 22/10/2025.
//

import SwiftUI

struct FlightListView: View {
    
    // MARK: - Public
    let flights: [Flight]
    var title: String
    var searchCountPassengers: Int
    
    @Binding var path: NavigationPath
    
    // MARK: - Private
    @State private var navigateToBooking = false
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - TODO: Put in Constants
    private let titleSize: CGFloat = 15
    private let subtitleSize: CGFloat = 13
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<6) { index in
                    ForEach(flights) { flight in
                        Button {
                            path.append(FlightPage.booking(
                                flight: flight,
                                searchCountPassengers: searchCountPassengers
                            ))
                            
                            Haptics.light()
                            
                        } label: {
                            FlightListItemView(
                                flight: flight,
                                searchCountPassengers: searchCountPassengers
                            )
                        }
                        .padding()
                        .foregroundStyle(Constants.Colors.textPrimary)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                .fill(Constants.Colors.background)
                        )
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .background(Constants.Colors.backgroundApp)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

