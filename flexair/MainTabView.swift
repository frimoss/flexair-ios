//
//  ContentView.swift
//  flexair
//
//  Created by Nikolai on 21/10/2025.
//

import SwiftUI

enum AppTab: Hashable {
    case home, tickets, profile
}

struct MainTabView: View {
    
    @State private var selection: AppTab = .home
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Flights", systemImage: "airplane", value: AppTab.home) {
                NavigationStack {
                    SearchFlightsView()
                }
                .tag(AppTab.home)
            }
            
            Tab("Tickets", systemImage: "barcode.viewfinder", value: AppTab.tickets) {
                NavigationStack {
                    //
                }
                .tag(AppTab.tickets)
            }
            
            Tab("Profile", systemImage: "person.crop.circle", value: AppTab.profile) {
                NavigationStack {
                    //
                }
                .tag(AppTab.profile)
            }
        }
    }
}

#Preview {
    MainTabView()
}
