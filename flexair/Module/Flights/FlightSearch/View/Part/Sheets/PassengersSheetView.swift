//
//  PassengersSheetView.swift
//  flexair
//
//  Created by Nikolai on 22/12/2025.
//

import SwiftUI

struct PassengersSheetView: View {
    @Binding var adultsCount: Int
    @Binding var childrenCount: Int
    var clear: () -> Void
    
    @State private var showAlert = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 36) {
                    VStack(spacing: 24) {
                        PassengersSheetItemView(
                            title: "Adults",
                            description: "Over 12 years old",
                            counter: $adultsCount
                        )
                        PassengersSheetItemView(
                            title: "Children",
                            description: "Ages 2 to 12",
                            counter: $childrenCount
                        )
                    }
                    
                    Button("Select") {
                        if adultsCount + childrenCount >= 1 {
                            dismiss()
                        } else {
                            Haptics.error()
                            showAlert = true
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
            }
            .navigationTitle("Passengers")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.fraction(0.35)])
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        clear()
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("At least 1 passenger must be selected")
            }
        }
    }
}

struct PassengersSheetItemView: View {
    
    var title: String
    var description: String
    
    @Binding var counter: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 20))
                
                Text(description)
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                // Minus
                Button {
                    if counter > 0 { // Min: 0
                        counter -= 1
                        Haptics.light()
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white).opacity(0.8)
                        .frame(width: 44, height: 44)
                        .background(.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .disabled(counter == 0)
                
                Text("\(counter)")
                    .font(.system(size: 22, weight: .bold).monospacedDigit())
                
                // Plus
                Button {
                    if counter < 5 { // Max: 5
                        counter += 1
                        Haptics.light()
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .bold))
                        .frame(width: 44, height: 44)
                        .background(.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .disabled(counter == 5)
            }
        }
    }
}

