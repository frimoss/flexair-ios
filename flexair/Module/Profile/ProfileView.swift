//
//  ProfileView.swift
//  flexair
//
//  Created by Nikolai on 22/10/2025.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var authService = AuthService.shared
    
    // MARK: - Alert
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            if let profile = authService.getUserProfile() {
                Form {
                    Section {
                        HStack(alignment: .center) {
                            Spacer()
                            
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 90, height: 90)
                                .foregroundStyle(Constants.Colors.accent)
                            
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                    Section("Account") {
                        
                        Button {
                            //
                        } label: {
                            HStack {
                                Text("Email")
                                Spacer()
                                Text(profile.email ?? "N/A") //userEmail
                            }
                            .foregroundStyle(Constants.Colors.textPrimary)
                        }
                        
                        Button {
                            //
                        } label: {
                            HStack {
                                Text("Password")
                                    .foregroundStyle(Constants.Colors.textPrimary)
                                
                                Spacer()
                                
                                Text("••••••••")
                                    .font(.system(size: 24, weight: .heavy))
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                        HStack {
                            Text("Created at:")
                            Spacer()
                            if let createdAt = profile.createdAt {
                                Text(createdAt.formatted())
                                    .foregroundStyle(.gray)
                            } else {
                                Text("N/A")
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                    }
                    
                    Button {
                        showAlert = true
                    } label: {
                        Text("Sign Out")
                            .foregroundStyle(.red)
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image("icon")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                
                                Text("Flexair 1.0")
                                .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(.gray)
                                  
                                VStack(spacing: 4) {
                                    Text("Flight Booking DBMS")
                                    Text("CMPE344 Project")
                                    Text("22.12.2025")
                                }
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .background(Constants.Colors.backgroundApp)
                .alert("Sign out", isPresented: $showAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Sign out", role: .destructive) {
                        Task {
                            await authService.signOut()
                            // Update Auth State
                            appState.updateState()
                        }
                    }
                } message: {
                    Text("Are you sure you want to sign out of your account?")
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
