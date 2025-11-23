//
//  FlightListItemView.swift
//  flexair
//
//  Created by Nikolai on 23/11/2025.
//

import SwiftUI

struct FlightListItemView: View {
    
    var price: Int
    var originCode: String
    var destinationCode: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("$\(price)") // MARK: Price
                        .font(.system(size: 25, weight: .heavy))
                    
                    Text("$98 including baggage 1×23 kg")
                        .font(.system(size: 14, weight: .regular))
                        .padding(3)
                        .padding(.horizontal, 2)
                        .background(
                            .gray
                                .opacity(0.2)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
                }
                
                Spacer()
                
                Button {
                    //
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Constants.Colors.textPrimary)
                        .padding(10)
                        .background(
                            .gray
                                .opacity(0.2)
                        )
                        .clipShape(Circle())
                        .shadow(radius: 8)
                }
            }
            
            HStack(alignment: .center, spacing: 12) {
                Image("TurkishAirlines")
                    .resizable()
                    .frame(width: 25, height: 25)
                
                HStack(alignment: .top, spacing: 1) {
                    VStack(alignment: .leading) {
                        Text("13:50")
                        
                        Text(originCode) // MARK: Origin Code
                            .foregroundStyle(.gray)
                    }
                    Text("—")
                        .foregroundStyle(.gray)
                    
                    VStack(alignment: .leading) {
                        Text("16:50")
                        
                        Text(destinationCode) // MARK: Destination Code
                            .foregroundStyle(.gray)
                    }
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("Travel time: 14h")
                        
                        Text("/")
                            .foregroundStyle(.gray)
                        
                        Text("0 layovers")
                    }
                    .padding(.leading, 14)
                }
                
            }
            .font(.system(size: 13, weight: .regular))
        }
    }
}

#Preview {
    FlightListItemView(price: 250, originCode: "IST", destinationCode: "SVO")
}
