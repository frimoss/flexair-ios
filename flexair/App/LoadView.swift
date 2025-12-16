//
//  LoadView.swift
//  flexair
//
//  Created by Nikolai on 11/12/2025.
//

import SwiftUI

struct LoadView: View {
    var body: some View {
        VStack {
            VStack(spacing: 6) {
                Image(systemName: "airplane")
                    .font(.system(size: 24))
                
                Text("Flexair")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(Constants.Colors.textAccent)
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.Colors.accent)
    }
}

#Preview {
    LoadView()
}
