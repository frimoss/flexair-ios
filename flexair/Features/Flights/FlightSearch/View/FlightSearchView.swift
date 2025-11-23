//
//  FlightSearchView.swift
//  flexair
//
//  Created by Nikolai on 25/10/2025.
//

import SwiftUI

struct FlightSearchView: View {

    @State private var departure: String = "Istanbul, IST"
    @State private var destination: String = ""
    @State private var selectedDate = Date()
    @State private var selectedDateText = "Travel dates"
    
    // Flags
    @State private var showAirportListDeparture = false
    @State private var showAirportListDestination = false
    @State private var showDatePicker = false
    @State private var isDateSelected = false
    
    @State private var showPassengers = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        ZStack(alignment: .trailing) {
                            VStack(spacing: 12) {
                                // From
                                SearchFlightButtonView(title: "From", userInput: departure) {
                                    showAirportListDeparture = true
                                }
                                // To where
                                SearchFlightButtonView(title: "To", userInput: destination) {
                                    showAirportListDestination = true
                                }
                            }
                            
                            Button {
                                let text = departure
                                departure = destination
                                destination = text
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
                    
                    NavigationLink {
                        FlightListView()
                    } label: {
                        Text("Find tickets")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Flexair")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAirportListDeparture) {
                AirportListView(navTitle: "From", userInput: $departure)
            }
            .sheet(isPresented: $showAirportListDestination) {
                AirportListView(navTitle: "To", userInput: $destination)
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerView(selectedDate: $selectedDate, selectedDateText: $selectedDateText, isDateSelected: $isDateSelected)
            }
            .navigationBarBackButtonHidden()
            .background(Constants.Colors.backgroundApp)
        }
    }
}

#Preview {
    FlightSearchView()
}
