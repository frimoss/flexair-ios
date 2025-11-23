//
//  FlightListView.swift
//  flexair
//
//  Created by Nikolai on 22/10/2025.
//

import SwiftUI

struct FlightListView: View {
    
    let flights: [Flight]
    var title: String
    
    private let titleSize: CGFloat = 15
    private let subtitleSize: CGFloat = 13
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(flights) { flight in
                    NavigationLink {
                        //PaymentView()
                    } label: {
                        FlightListItemView(price: flight.price, originCode: flight.originCode, destinationCode: flight.destinationCode)
                    }
                    .padding()
                    .foregroundStyle(Constants.Colors.textPrimary)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                            .fill(Constants.Colors.background)
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .background(Constants.Colors.backgroundApp)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

