//
//  FlightBookingView.swift
//  flexair
//
//  Created by Nikolai on 27/10/2025.
//

import SwiftUI

struct FlightBookingView: View {
    @State private var viewModel = BookingViewModel()
    
    // MARK: - Public
    var flight: Flight
    @State var searchCountPassengers: Int
    
    @Binding var homeNavigationPath: NavigationPath
    @Binding var bookingNavigationPath: NavigationPath
    @Binding var tab: AppTab
    
    // MARK: - Private
    @State private var selectedPassengers: [Passenger] = []
    @Environment(\.dismiss) private var dismiss
    
    private var numberOfPassengers: Int {
        if selectedPassengers.count > 0 {
            return selectedPassengers.count
        } else {
            return searchCountPassengers
        }
    }
    
    private var numberOfPassengersTitle: String {
        numberOfPassengers > 1
            ? "for \(numberOfPassengers) passengers"
            : "for 1 passenger"
    }
    
    private var passengerPrice: Int {
        return flight.flightPrice
            + (hasBaggage ? flight.baggagePrice : 0)
            + (hasRefund ? flight.refundPrice : 0)
    }
    
    private var totalPrice: Int {
        let multiplier = numberOfPassengers > 1
            ? numberOfPassengers
            : 1
        
        return passengerPrice * multiplier
    }

    // Flags
    @State private var hasBaggage: Bool = false
    @State private var hasRefund: Bool = false
    @State private var showPassengers: Bool = false
    
    @State private var isBookingCreated: Bool = false
    
    // Constants
    private let titleSize: CGFloat = 15
    private let subtitleSize: CGFloat = 13
    
    // Alert
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Price
                    VStack(spacing: 4) {
                        Text("$\(totalPrice)")
                            .font(.system(size: 32, weight: .heavy))
                        
                        Text(numberOfPassengersTitle)
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
                            Toggle(isOn: $hasBaggage) {
                                HStack(spacing: 4) {
                                    Text("Add baggage")
                                    Text("+$\(flight.baggagePrice)")
                                        .foregroundColor(.blue)
                                        .fontWeight(.medium)
                                }
                            }
                            
                            VStack{
                                Color.gray.frame(height: 1 / UIScreen.main.scale)
                                    .opacity(0.3)
                            }
                            
                            Toggle(isOn: $hasRefund) {
                                HStack(spacing: 4) {
                                    Text("Refund/exchange")
                                    Text("+$\(flight.refundPrice)")
                                        .foregroundColor(.blue)
                                        .fontWeight(.medium)
                                }
                            }
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
                                Text(flight.route)
                                    .font(.system(size: 16, weight: .bold))
                                Text(flight.duration)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                        .padding(.leading, 12)
                        
                        // Box Flight Info
                        FlightInfoView(flight: flight)
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
                            if !selectedPassengers.isEmpty {
                                ForEach(selectedPassengers) { passenger in
                                    Button {
                                        showPassengers = true
                                    } label: {
                                        HStack(spacing: 14) {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundStyle(Constants.Colors.accent)
                                            Text(passenger.fullName)
                                                .font(.system(size: titleSize, weight: .medium))
                                            
                                            Spacer()
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                                .fill(Constants.Colors.backgroundLight)
                                        )
                                    }
                                }
                            } else {
                                Button {
                                    showPassengers = true
                                } label: {
                                    HStack(spacing: 14) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundStyle(Constants.Colors.accent)
                                        Text("Add Passenger")
                                            .font(.system(size: titleSize, weight: .medium))
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                            .fill(Constants.Colors.backgroundLight)
                                    )
                                }
                            }

                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                                .fill(Constants.Colors.background)
                        )
                    }
                    
                    Button {
                        if selectedPassengers.isEmpty {
                            alertMessage = "Add at least one Passenger"
                            showAlert = true
                            Haptics.error()
                            return
                        }
                        
                        Task {
                            for passenger in selectedPassengers {
                                do {
                                    try await viewModel.createBooking(
                                        flightId: flight.flightId,
                                        passengerId: passenger.passengerId,
                                        totalPrice: passengerPrice
                                    )
                                } catch {
                                    Haptics.error()
                                    print("❌ Booking failed for \(passenger.fullName): \(error)")
                                }
                            }
                            isBookingCreated = true
                            alertMessage = "Booking was successfully completed"
                            Haptics.success()
                            showAlert = true
                        }
                    } label: {
                        Text("Buy ticket for $\(totalPrice)")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
                .foregroundStyle(Constants.Colors.textPrimary)
            }
            .background(Constants.Colors.backgroundApp)
            .scrollIndicators(.hidden)
        }
        .sheet(isPresented: $showPassengers) {
            PassengersView(selectedPassengers: $selectedPassengers)
                .interactiveDismissDisabled()
        }
        .alert(isBookingCreated ? alertMessage : "Error", isPresented: $showAlert) {
            Button(isBookingCreated ? "Go to booking" : "OK", role: .cancel) {
                
                if isBookingCreated, let booking = viewModel.completedBooking {
                    // MARK: Navigation in the Start + Change Tab to Bookings
                    homeNavigationPath = NavigationPath() // = []
                    bookingNavigationPath = NavigationPath() // = []
                    bookingNavigationPath.append(booking)
                    tab = .userBookings
                }
                
            }
        } message: {
            Text(!isBookingCreated ? alertMessage : "")
        }
        .navigationTitle("Booking")
        .navigationBarTitleDisplayMode(.inline)
    }
}
