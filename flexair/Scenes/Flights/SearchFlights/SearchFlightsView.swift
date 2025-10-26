//
//  SearchFlightsView.swift
//  flexair
//
//  Created by Nikolai on 25/10/2025.
//

import SwiftUI

struct SearchFlightsView: View {
    
    @State private var fromWhere: String = "Istanbul, IST"
    @State private var toWhere: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    ZStack(alignment: .trailing) {
                        VStack(spacing: 12) {
                            // From
                            SearchFlightButtonView(title: "From", userInput: fromWhere) {
                                
                            }
                            // To where
                            SearchFlightButtonView(title: "To", userInput: toWhere) {
                                
                            }
                        }
                        
                        Button {
                            //
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .buttonStyle(ArrowButtonStyle())
                        .padding(.horizontal, 12)
                        
                    }
                    
                    HStack(spacing: 12) {
                        // Travel Dates
                        SearchFlightButtonView(title: "Travel dates", image: "Calendar") {
                            
                        }
                        // Passenger
                        SearchFlightButtonView(title: "1 pass, Economy", image: "Passenger", isPrimaryColor: true) {
                            
                        }
                    }
                    
                }

                Button("Find tickets") {
                    
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Spacer()
            }
            .navigationTitle("Flexair")
            .padding()
        }
    }
}

#Preview {
    SearchFlightsView()
}
