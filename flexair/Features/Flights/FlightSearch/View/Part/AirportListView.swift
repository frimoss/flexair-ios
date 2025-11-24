//
//  AirportListView.swift
//  flexair
//
//  Created by Nikolai on 21/11/2025.
//

import SwiftUI

struct AirportListView: View {
    
    // MARK: - Public
    @Binding var selected: Airport?
    var title: String
    
    // MARK: - Private
    @State private var searchText = ""
    
    private let airports: [Airport] = airportData
    
    @Environment(\.dismiss) private var dismiss
    
    // Filtered result (computed each time search changes)
    private var filteredAirports: [Airport] {
        if searchText.isEmpty {
            return airports //[]
        } else {
            return airports.filter { airport in
                airport.city.localizedCaseInsensitiveContains(searchText) ||
                airport.country.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(filteredAirports) { airport in
                    Button {
                        selected = airport
                        dismiss()
                    } label: {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(airport.name)
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundStyle(Constants.Colors.textPrimary)
                                
                                Text(airport.city + ", " +  airport.country)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(airport.code)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .searchable(text: $searchText, prompt: "City, country")
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
}
