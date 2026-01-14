//
//  FlightListItemView.swift
//  flexair
//
//  Created by Nikolai on 23/11/2025.
//

import SwiftUI

struct FlightListItemView: View {
    
    // MARK: - Public
    var flight: Flight
    var searchCountPassengers: Int
    
    // MARK: - Private
    private var price: Int {
        return flight.flightPrice * searchCountPassengers
    }
    private var baggagePrice: Int {
        return (flight.flightPrice + flight.baggagePrice) * searchCountPassengers
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("$\(price)")
                        .font(.system(size: 25, weight: .heavy))
                    
                    Text("$\(baggagePrice) including baggage 1×23 kg")
                        .font(.system(size: 14, weight: .regular))
                        .padding(3)
                        .padding(.horizontal, 2)
                        .background(
                            .gray
                                .opacity(0.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
                }
                
                Spacer()
                
                Button {
                    //
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Constants.Colors.textPrimary)
                        .padding(10)
                        .background(
                            .gray
                            .opacity(0.2)
                        )
                        .clipShape(Circle())
                        .shadow(radius: 8)
                }
            }
            
            HStack(alignment: .center, spacing: 12) {
                Image(flight.airlineCode)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                
                HStack(alignment: .top, spacing: 1) {
                    VStack(alignment: .leading) {
                        Text(flight.formattedDepartureTime)
                        
                        Text(flight.departureAirportCode) // MARK: Departure Code
                            .foregroundStyle(.gray)
                    }
                    Text("—")
                        .foregroundStyle(.gray)
                    
                    VStack(alignment: .leading) {
                        Text(flight.formattedArrivalTime)
                        
                        Text(flight.arrivalAirportCode) // MARK: Destination Code
                            .foregroundStyle(.gray)
                    }
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("Travel time: \(flight.duration)")
                    }
                    .padding(.leading, 14)
                }
                
            }
            .font(.system(size: 14, weight: .regular))
        }
    }
}
