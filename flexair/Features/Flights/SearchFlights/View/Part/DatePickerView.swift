//
//  DatePickerView.swift
//  flexair
//
//  Created by Nikolai on 21/11/2025.
//

import SwiftUI

struct DatePickerView: View {
    
    @Binding var selectedDate: Date
    
    @State var todayDate = Date()

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                DatePicker("Select Date", selection: $todayDate, in: Date.now..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                
                Button("Select a date") {
                    selectedDate = todayDate
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
