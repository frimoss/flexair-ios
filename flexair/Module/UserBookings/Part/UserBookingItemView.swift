//
//  UserBookingItemView.swift
//  flexair
//
//  Created by Nikolai on 14/12/2025.
//

import SwiftUI

struct UserBookingItemView: View {
    @State private var viewModel = BookingViewModel()
    
    let userBooking: UserBooking
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Alert
    // Cancellation Alert
    @State private var showCancellationAlert = false
    @State private var isCancellationSuccess = false
    
    // Success/Error Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            
            VStack(spacing: 12) {
                Image("qrcode")
                    .resizable()
                    .frame(width: 220, height: 220)
                
                Text("Scan this QR-Code")
                    .font(.system(size: 14, weight: .medium))
            }

            BookingInfoView(userBooking: userBooking)
            
            Button {
                showCancellationAlert = true
            } label: {
                Text("Cancel booking")
                    .font(.system(size: 15))
                    .foregroundStyle(.red)
            }
            Spacer()
        }
        .padding()
        .background(Constants.Colors.backgroundApp)
        .navigationTitle("Booking #\(userBooking.bookingId)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isCancellationSuccess ? "Success" : "Error", isPresented: $showAlert) {
            Button(isCancellationSuccess ? "Continue" : "OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
        .alert("Cancel Booking", isPresented: $showCancellationAlert) {
            Button("Keep Booking", role: .cancel) { }
            Button("Cancel Booking", role: .destructive) {
                Task {
                    do {
                        try await viewModel.cancelBooking(bookingId: userBooking.id)
                        isCancellationSuccess = true
                        alertMessage = "Booking successfully cancelled"
                    } catch {
                        isCancellationSuccess = false
                        alertMessage = viewModel.errorMessage ?? ""
                    }
                    showAlert = true
                }
            }
        } message: {
            Text("Are you sure you want to cancel this booking? This action cannot be undone.")
        }
    }
}
