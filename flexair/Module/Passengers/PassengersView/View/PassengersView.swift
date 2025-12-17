//
//  PassengersView.swift
//  flexair
//
//  Created by Nikolai on 31/10/2025.
//

import SwiftUI

struct PassengersView: View {
    @State private var viewModel = PassengerViewModel()
    
    @Binding var selectedPassengers: [Passenger]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                VStack(spacing: 12) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if viewModel.passengers.isEmpty {
                        // Empty state
                        VStack(alignment: .center, spacing: 14) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 60))
                                .foregroundStyle(Constants.Colors.accent)
                            VStack(spacing: 10) {
                                Text("No passengers yet")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Add your first passenger to continue")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                                NavigationLink {
                                    AddPassengerView()
                                } label: {
                                    Text("Add new Passenger")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Constants.Colors.accent)
                                        .padding(.top, 8)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    
                    } else {
                        ScrollView {
                            ForEach(viewModel.passengers) { passenger in
                                PassengerItem(
                                    passenger: passenger,
                                    isSelected: isSelected(passenger)
                                ) {
                                    toggleSelection(passenger)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Button {
                    dismiss()
                } label: {
                    Text("Select Passenger")
                        .font(.system(size: 18, weight: .regular))
                }
                .opacity(selectedPassengers.isEmpty ? 0 : 1)
                .disabled(selectedPassengers.isEmpty)
                .buttonStyle(PrimaryButtonStyle())
                .padding()
            }
            .navigationTitle("Passengers")
            .navigationBarTitleDisplayMode(.inline)
            .background(Constants.Colors.backgroundApp)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddPassengerView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                // Load User's Passengers before this View appears
                await viewModel.loadPassengers()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func isSelected(_ passenger: Passenger) -> Bool {
        selectedPassengers.contains { $0.id == passenger.id }
    }
    
    private func toggleSelection(_ passenger: Passenger) {
        if let index = selectedPassengers.firstIndex(where: { $0.id == passenger.id }) {
            // ✅ Remove if already selected
            selectedPassengers.remove(at: index)
        } else {
            // ✅ Add if not selected
            selectedPassengers.append(passenger)
            Haptics.light()
        }
    }
}

#Preview {
    @State var passengers: [Passenger] = []
    PassengersView(selectedPassengers: $passengers)
}
