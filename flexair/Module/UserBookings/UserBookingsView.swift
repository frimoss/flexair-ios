//
//  UserBookingsView.swift
//  flexair
//
//  Created by Nikolai on 03/12/2025.
//

import SwiftUI

struct UserBookingsView: View {    
    @State private var viewModel = BookingViewModel()
    
    var body: some View {
        VStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.userBookings.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "airplane")
                            .font(.system(size: 30))
                            .foregroundStyle(Constants.Colors.accent)
                        Text("No Bookings found")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.userBookings) { booking in
                                NavigationLink(value: booking) {
                                    // Booking View
                                    BookingInfoView(userBooking: booking)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Bookings")
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Constants.Colors.backgroundApp)
            .task {
                // Load User's Passengers before this View appears
                await viewModel.loadBookings()
            }
        }
    }
}

//#Preview {
//    UserBookingsView()
//}
