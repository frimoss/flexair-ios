//
//  MainTabView.swift
//  flexair
//
//  Created by Nikolai on 21/10/2025.
//

import SwiftUI

enum AppTab: Hashable {
    case home, userBookings, favorites, profile
}

enum FlightPage: Hashable {
    case list(flights: [Flight], title: String, searchCountPassengers: Int)
    case booking(flight: Flight, searchCountPassengers: Int)
}

struct MainTabView: View {
    @State private var selection: AppTab = .home
    
    @State private var homeNavigationPath = NavigationPath()
    @State private var bookingNavigationPath = NavigationPath()
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Flights", systemImage: "airplane", value: AppTab.home) {
                NavigationStack(path: $homeNavigationPath) {
                    FlightSearchView(path: $homeNavigationPath)
                    .navigationDestination(for: FlightPage.self) { page in
                        switch page {
                            
                        case .list(let flights, let title, let searchCountPassengers):
                            FlightListView(
                                flights: flights,
                                title: title,
                                searchCountPassengers: searchCountPassengers,
                                path: $homeNavigationPath
                            )
                            
                        case .booking(let flight, let searchCountPassengers):
                            FlightBookingView(
                                flight: flight,
                                searchCountPassengers: searchCountPassengers,
                                homeNavigationPath: $homeNavigationPath,
                                bookingNavigationPath: $bookingNavigationPath,
                                tab: $selection
                            )
                        }
                    }
                }
                .tag(AppTab.home)
            }
            
            Tab("Bookings", systemImage: "barcode.viewfinder", value: AppTab.userBookings) {
                NavigationStack(path: $bookingNavigationPath) {
                    UserBookingsView()
                        .navigationDestination(for: UserBooking.self) { booking in
                            UserBookingItemView(userBooking: booking)
                        }
                }
                .tag(AppTab.userBookings)
            }
            
            Tab("Profile", systemImage: "person.crop.circle", value: AppTab.profile) {
                NavigationStack {
                    //HomeView()
                    ProfileView()
                }
                .tag(AppTab.profile)
            }
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
    }
}

#Preview {
    MainTabView()
}
