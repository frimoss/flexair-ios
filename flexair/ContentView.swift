//
//  ContentView.swift
//  flexair
//
//  Created by user on 21/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "airplane")
                .imageScale(.large)
            Text("Flexair")
                .font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow)
    }
}

#Preview {
    ContentView()
}
