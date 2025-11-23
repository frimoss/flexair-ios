//
//  FlightSearchView.swift
//  flexair
//
//  Created by Nikolai on 25/10/2025.
//

import SwiftUI

struct FlightSearchView: View {
    
    @State private var flightVM = FlightSearchViewModel()
    @State private var navigateToFlights = false
    
    // Airports
    @State private var originAirport: Airport? = airportData[0] // Default: "Istanbul, IST"
    @State private var destinationAirport: Airport? = nil
    
    @State private var showAirportListOrigin = false
    @State private var showAirportListDestination = false
    
    // Date
    @State private var selectedDate = Date()
    @State private var selectedDateText = "Travel dates"
    @State private var isDateSelected = false
    @State private var showDatePicker = false
    
    // Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        ZStack(alignment: .trailing) {
                            VStack(spacing: 12) {
                                // From
                                SearchFlightButtonView(title: "From", userInput: originAirport?.displayName ?? "") {
                                    showAirportListOrigin = true
                                }
                                // To where
                                SearchFlightButtonView(title: "To", userInput: destinationAirport?.displayName ?? "") {
                                    showAirportListDestination = true
                                }
                            }
                            
                            Button {
                                let airport = originAirport
                                originAirport = destinationAirport
                                destinationAirport = airport
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
                                
                            }
                        }
                        
                    }
                    
                    Button("Get tickets") {
                        guard let originCode = originAirport?.code else {
                            alertMessage = "Please select origin Airport."
                            showAlert = true
                            return
                        }
                        
                        guard let destinationCode = destinationAirport?.code else {
                            alertMessage = "Please select destination Airport."
                            showAlert = true
                            return
                        }
                        
                        if !isDateSelected {
                            alertMessage = "Please select the flight date."
                            showAlert = true
                            return
                        }
                        
                        let departureDate = selectedDate.toAPIFormat()
                        
                        print()
                        print("Origin: \(originCode)")
                        print("Destination: \(destinationCode)")
                        print("Date: \(departureDate)")
                        
                        flightVM.origin = originCode
                        flightVM.destination = destinationCode
                        flightVM.departureDate = departureDate
                        
                        Task {
                            await flightVM.searchFlights()
                            
                            print("✅ Found \(flightVM.flights.count) flights")
                            
                            if flightVM.flights.count == 0 {
                                alertMessage = "Flights were not found. Try to change Airport."
                                showAlert = true
                            } else {
                                // MARK: Navigation to Flight List
                                navigateToFlights = true
                            }
                            
                            if let error = flightVM.errorMessage {
                                alertMessage = error
                                showAlert = true
                            }
                        }
                        
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Flexair")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .background(Constants.Colors.backgroundApp)
            .sheet(isPresented: $showAirportListOrigin) {
                AirportListView(selected: $originAirport, title: "From")
            }
            .sheet(isPresented: $showAirportListDestination) {
                AirportListView(selected: $destinationAirport, title: "To")
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerView(selectedDate: $selectedDate, selectedDateText: $selectedDateText, isDateSelected: $isDateSelected)
            }
            .navigationDestination(isPresented: $navigateToFlights) {
                if let originCity = originAirport?.city, let destinationCity = destinationAirport?.city {
                    
                    let title = "\(originCity) — \(destinationCity)" // "Istanbul — Los Angeles"
                    
                    FlightListView(flights: flightVM.flights, title: title)
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

#Preview {
    FlightSearchView()
}
