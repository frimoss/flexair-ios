//
//  CountryPickerView.swift
//  flexair
//
//  Created by Nikolai on 01/12/2025.
//

import SwiftUI

struct CountryPickerView: View {
    @Binding var selectedCountry: Country?
    
    // MARK: Private
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    private var filteredCountries: [Country] {
        if searchText.isEmpty {
            return Country.all
        }
        return Country.search(searchText)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(filteredCountries) { country in
                    Button {
                        selectedCountry = country
                        dismiss()
                    } label: {
                        HStack {
                            Text(country.name)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(Constants.Colors.textPrimary)
                            Spacer()
                            if selectedCountry?.id == country.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .indexViewStyle(.page)
            }
            .searchable(text: $searchText, prompt: "Search countries")
            .navigationTitle("Nationality")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @State var country: Country?
    CountryPickerView(selectedCountry: $country)
}
