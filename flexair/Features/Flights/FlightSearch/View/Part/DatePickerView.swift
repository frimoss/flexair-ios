//
//  DatePickerView.swift
//  flexair
//
//  Created by Nikolai on 21/11/2025.
//

import SwiftUI

struct DatePickerView: View {
    
    @Binding var selectedDate: Date
    @Binding var selectedDateText: String
    @Binding var isDateSelected: Bool

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                DatePicker("Select Date", selection: $selectedDate, in: Date.now..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .frame(minHeight: 360)

                Button("Select a date") {
                    isDateSelected = true
                    selectedDateText = selectedDate.toDayMonthWeek()
                    dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Flight date")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.fraction(0.66)])
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        selectedDateText = "Travel dates"
                        isDateSelected = false
                        selectedDate = Date()
                        dismiss()
                    } label: {
                        Text("Clear")
                    }
                }
            }
        }
    }
}

extension Date {
    func toDayMonthWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, EEE"   // "22 Nov, Sat"
        return formatter.string(from: self)
    }
}
