//
//  DatePickerView.swift
//  flexair
//
//  Created by Nikolai on 21/11/2025.
//

import SwiftUI

struct DatePickerView: View {
    
    @Binding var selectedDate: Date
    
    @State var currentDate = Date()

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                DatePicker("Select Date", selection: $currentDate, in: Date.now..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                Button("Select a date") {
                    selectedDate = currentDate
                    print("selectedDate: \(selectedDate)")
                    dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Choose a Date")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.large])
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
