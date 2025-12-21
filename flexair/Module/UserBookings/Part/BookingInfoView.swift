//
//  BookingInfoView.swift
//  flexair
//
//  Created by Nikolai on 03/12/2025.
//

import SwiftUI

struct BookingInfoView: View {
    
    let userBooking: UserBooking
    
    // Constants
    private let titleSize: CGFloat = 15
    private let subtitleSize: CGFloat = 13
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .center, spacing: 0) {
                Text(userBooking.fullDepartureDate)
                    .font(.system(size: titleSize, weight: .semibold))
  
                Spacer()
                
                Text(userBooking.airlineName)
                    .font(.system(size: subtitleSize, weight: .semibold))
                    .padding(.trailing, 8)
                
                Image(userBooking.airlineCode)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
            }
            .padding(.leading, 2)
            .padding(.bottom, 8)
            
            // Arrival Time + Airports
            HStack(alignment: .top, spacing: 16) {
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(userBooking.formattedDepartureTime)
                            .font(.system(size: titleSize, weight: .medium))
                        
                        Text(userBooking.formattedDepartureDate)
                            .font(.system(size: subtitleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(userBooking.formattedArrivalTime)
                            .font(.system(size: titleSize, weight: .medium))
                        
                        Text(userBooking.formattedArrivalDate)
                            .font(.system(size: subtitleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(userBooking.departureCity)
                            .font(.system(size: titleSize, weight: .medium))
                        
                        Text(userBooking.departureAirportTitle) // "Istanbul New Airport, IST"
                            .font(.system(size: subtitleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(userBooking.arrivalCity)
                            .font(.system(size: titleSize, weight: .medium))
                        
                        Text(userBooking.arrivalAirportTitle)
                            .font(.system(size: subtitleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
            }
            
            // Circles
            HStack {
                Circle()
                    .frame(width: 30)
                    .foregroundStyle(Constants.Colors.backgroundApp)
                    .padding(.leading, -15)
                
                Line()
                   .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                   .frame(height: 1)
                   .foregroundStyle(Constants.Colors.textSecondary)
                
                Circle()
                    .frame(width: 30)
                    .foregroundStyle(Constants.Colors.backgroundApp)
                    .padding(.trailing, -15)
            }
            .padding(.horizontal, -16)
            
            // Logo + Airline Title
            HStack() {
                HStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Constants.Colors.accent)
                    
                    Text(userBooking.passengerFullName)
                        .font(.system(size: titleSize, weight: .medium))
                }
                
                Spacer()
                
                Text("PNR: \(userBooking.bookingReference)")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(Constants.Colors.background)
        )
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
