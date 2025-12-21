//
//  FlightSearchView.swift
//  flexair
//
//  Created by Nikolai on 25/10/2025.
//

import SwiftUI

struct FlightSearchView: View {
    
    // MARK: - Public
    @Binding var path: NavigationPath
    
    // MARK: - Private
    @State private var viewModel = FlightSearchViewModel()
    @State private var navigateToFlights = false
    
    // MARK: - Airports
    @State private var departureAirport: Airport? = airportData[0] // Default: "Istanbul, IST"
    @State private var arrivalAirport: Airport? = nil
    
    @State private var showAirportListOrigin = false
    @State private var showAirportListDestination = false
    
    // MARK: - Date
    @State private var selectedDate = Date()
    @State private var selectedDateText = "Travel dates"
    @State private var isDateSelected = false
    @State private var showDatePicker = false
    
    // MARK: - Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            VStack {
                VStack(spacing: 24) {
                    // MARK: Logo
                    LogoView()
                        .padding(.top, 24)
                    
                    // MARK: Input
                    VStack(spacing: 12) {
                        ZStack(alignment: .trailing) {
                            VStack(spacing: 12) {
                                // From
                                SearchFlightButtonView(title: "From", userInput: departureAirport?.displayName ?? "") {
                                    showAirportListOrigin = true
                                }
                                
                                // To where
                                SearchFlightButtonView(title: "To", userInput: arrivalAirport?.displayName ?? "") {
                                    showAirportListDestination = true
                                }
                            }
                            
                            Button {
                                let airport = departureAirport
                                departureAirport = arrivalAirport
                                arrivalAirport = airport
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                            }
                            .buttonStyle(ArrowButtonStyle())
                            .padding(.horizontal, 12)
                        }
                        
                        HStack(spacing: 12) {
                            // Travel Dates
                            SearchFlightButtonView(title: selectedDateText, image: "Calendar", isPrimaryColor: isDateSelected) {
                                showDatePicker = true
                            }
                            // Passenger
                            SearchFlightButtonView(title: "1 passenger", image: "Passenger", isPrimaryColor: false) {
                                // TODO: MVP 1 passenger
                            }
                        }
                        
                    }
                    
                    // MARK: Button "Get tickets"
                    Button("Get tickets") {
                        guard let departure = departureAirport else {
                            alertMessage = "Departure airport is not selected"
                            showAlert = true
                            Haptics.error()
                            return
                        }
                        guard let arrival = arrivalAirport else {
                            alertMessage = "Arrival airport is not selected"
                            showAlert = true
                            Haptics.error()
                            return
                        }
                        if departure.city == arrival.city {
                            alertMessage = "The departure and arrival airports cannot be the same"
                            showAlert = true
                            Haptics.error()
                            return
                        }
                        if !isDateSelected {
                            alertMessage = "Flight date is not selected"
                            showAlert = true
                            Haptics.error()
                            return
                        }
                        
                        Task {
                            await viewModel.searchFlights(
                                originCode: departure.airportCode,
                                destinationCode: arrival.airportCode,
                                departureDate: selectedDate
                            )
                            
                            if viewModel.flights.isEmpty {
                                alertMessage = "Flights not found. Try changing airports or the date of your trip"
                                showAlert = true
                                Haptics.error()
                                return
                            }
                            
                            Haptics.success()
                            
                            // Create Title: "Istanbul — Los Angeles"
                            let title = "\(departure.city) — \(arrival.city)"
                            
                            // Navigate to next List View
                            path.append(FlightPage.list(flights: viewModel.flights, title: title))
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Spacer()
                }
                .padding()
            }
            .background(Constants.Colors.backgroundApp)
            .sheet(isPresented: $showAirportListOrigin) {
                AirportListView(airports: viewModel.airports, selected: $departureAirport, title: "From")
            }
            .sheet(isPresented: $showAirportListDestination) {
                AirportListView(airports: viewModel.airports, selected: $arrivalAirport, title: "To")
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerView(selectedDate: $selectedDate, selectedDateText: $selectedDateText, isDateSelected: $isDateSelected)
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .task {
                // Load all Airports before this View appears
                await viewModel.loadAirports()
            }
            .onAppear {
                arrivalAirport = nil
                selectedDate = Date()
                selectedDateText = "Travel dates"
                isDateSelected = false
            }
        }
    }
}
