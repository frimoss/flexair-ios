//
//  LogoView.swift
//  flexair
//
//  Created by Nikolai on 20/12/2025.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("Fle")
            
            Image("logo-airplane")
                .resizable()
                .frame(width: 28, height: 28)
            
            Text("air")
        }
        .font(.system(size: 35, weight: .bold))
    }
}

#Preview {
    LogoView()
}
