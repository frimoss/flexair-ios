//
//  FlightBookingView.swift
//  flexair
//
//  Created by Nikolai on 27/10/2025.
//

import SwiftUI

struct FlightBookingView: View {
    
    @State var hasRefund: Bool = false
    @State var hasBaggage: Bool = false
    
    @State private var showPassengers: Bool = false
    
    private let titleSize: CGFloat = 15
    private let subtitleSize: CGFloat = 13
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Price
                    VStack(spacing: 4) {
                        Text("$76")
                            .font(.system(size: 32, weight: .heavy))
                        
                        Text("for 1 passenger")
                            .font(.system(size: titleSize, weight: .regular))
                            .foregroundStyle(.gray)
                    }
                    
                    // MARK: - Cheap Fare
                    VStack(alignment: .leading, spacing: 14) {
                        
                        Text("Cheap Fare")
                            .font(.system(size: 17, weight: .bold))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .frame(width: 15, height: 15)
                                
                                Text("Carry-on 1×8 kg")
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: hasBaggage ? "checkmark.circle.fill" : "multiply")
                                    .foregroundStyle(hasBaggage ? .green : .gray)
                                    .frame(width: 15, height: 15)
                                
                                Text(hasBaggage ? "Baggage 1×20 kg" : "Baggage not included")
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: hasRefund ? "checkmark.circle.fill" : "multiply")
                                    .foregroundStyle(hasRefund ? .green : .gray)
                                    .frame(width: 15, height: 15)
                                
                                Text(hasRefund ? "Exchangeable" : "Non-exchangeable")
                            }
                        }
                        
                        VStack(spacing: 10) {
                            Toggle("Add baggage", isOn: $hasBaggage)
                            
                            VStack{
                                Color.gray.frame(height: 1 / UIScreen.main.scale)
                                    .opacity(0.3)
                            }
                            
                            Toggle("Refund/exchange", isOn: $hasRefund)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                .fill(Constants.Colors.backgroundLight)
                        )
                        
                    }
                    .padding()
                    .font(.system(size: titleSize, weight: .regular))
                    .background(
                        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                            .fill(Constants.Colors.background)
                    )
                    
                    // MARK: - Flight Info
                    VStack(spacing: 10) {
                        // Title of Box
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Istanbul — Los Angeles")
                                    .font(.system(size: 16, weight: .bold))
                                Text("9h 5m")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                        .padding(.leading, 12)
                        
                        // Box Flight Info
                        VStack(alignment: .leading, spacing: 12) {
                            
                            // Logo + Airline Title
                            HStack(spacing: 12) {
                                Image("TurkishAirlines")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Turkish Airlines")
                                        .font(.system(size: titleSize, weight: .medium))
                                    
                                    Text("13h 45m")
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                            }
                            
                            // Arrival Time + Airports
                            HStack(alignment: .top, spacing: 16) {
                                VStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("13:50")
                                            .font(.system(size: titleSize, weight: .medium))
                                        
                                        Text("Tue, 18 Nov")
                                            .font(.system(size: subtitleSize, weight: .regular))
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("18:50")
                                            .font(.system(size: titleSize, weight: .medium))
                                        
                                        Text("Wed, 19 Nov")
                                            .font(.system(size: subtitleSize, weight: .regular))
                                            .foregroundStyle(.gray)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Istanbul")
                                            .font(.system(size: titleSize, weight: .medium))
                                        
                                        Text("Istanbul New Airport, IST")
                                            .font(.system(size: subtitleSize, weight: .regular))
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Los Angeles")
                                            .font(.system(size: titleSize, weight: .medium))
                                        
                                        Text("Sochi International Airport, AER")
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
                    
                    // MARK: - Add Passengers
                    VStack(spacing: 10) {
                        // Title of Box
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Passengers")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Add passenger(s)")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            
                            Button {
                                showPassengers.toggle()
                            } label: {
                                Text("Add")
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .font(.system(size: 15))
                                    .foregroundStyle(Constants.Colors.textAccent)
                                    .background(
                                        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                            .fill(Constants.Colors.accent)
                                    )
                            }
                        }
                        .padding(.horizontal, 12)
                        
                        // Passengers
                        VStack(spacing: 10) {
                            HStack(spacing: 14) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Constants.Colors.accent)
                                Text("Nikolai Piatnov")
                                    .font(.system(size: titleSize, weight: .medium))
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                    .fill(Constants.Colors.backgroundLight)
                            )
                            
                            HStack(spacing: 14) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Constants.Colors.accent)
                                Text("Ariana Pyatnova")
                                    .font(.system(size: titleSize, weight: .medium))
                                    //.foregroundStyle(Constants.Colors.accent)
                                
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                    .fill(Constants.Colors.backgroundLight)
                            )
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                .fill(Constants.Colors.background)
                        )
                    }
                    
                    Button {
                        //
                    } label: {
                        Text("Buy ticket for $76")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
                .padding(.bottom, 100)
                .foregroundStyle(Constants.Colors.textPrimary)
            }
            .background(Constants.Colors.backgroundApp)
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPassengers) {
            PassengersView()
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    FlightBookingView()
}
