//
//  FlightInfoView.swift
//  flexair
//
//  Created by user on 03/12/2025.
//

import SwiftUI

struct FlightInfoView: View {
    
    var flight: Flight
    
    private let titleSize: CGFloat = 15
    private let subtitleSize: CGFloat = 13
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Logo + Airline Title
            HStack(spacing: 12) {
                Image(flight.airlineCode)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(flight.airlineName)
                        .font(.system(size: titleSize, weight: .medium))
                    
                    Text(flight.duration)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
            
            // Arrival Time + Airports
            HStack(alignment: .top, spacing: 16) {
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(flight.formattedDepartureTime)
                            .font(.system(size: titleSize, weight: .medium))
                        
                        Text(flight.formattedDepartureDate)
                            .font(.system(size: subtitleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(flight.formattedArrivalTime)
                            .font(.system(size: titleSize, weight: .medium))
                        
                        Text(flight.formattedArrivalDate)
                            .font(.system(size: subtitleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(flight.departureCity)
                            .font(.system(size: titleSize, weight: .medium))
                        
                        Text(flight.departureAirportTitle) // "Istanbul New Airport, IST"
                            .font(.system(size: subtitleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(flight.arrivalCity)
                            .font(.system(size: titleSize, weight: .medium))
                        
                        Text(flight.arrivalAirportTitle)
                            .font(.system(size: subtitleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(Constants.Colors.background)
        )
    }
}
