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
        VStack {
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
                            VStack(spacing: 12) {
                                Image("icon")
                                    .resizable()
                                    .frame(width: 38, height: 38)
                                
                                Text("Flexair 1.52")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.gray)
                                  
                                VStack(spacing: 8) {
                                    Text("[Nikolai Piatnov](https://www.linkedin.com/in/piatnovn/)")
                                    Text("[Mahan Mizani](https://www.linkedin.com/in/mahan-mizani-180486149/)")
                                    Text("[Marcel Tshidibi Ngoyi](https://www.linkedin.com/in/marcel-ngoyi-470408374/)")
                                    Text("[Maksim Kalmykov](https://www.linkedin.com/in/maksim-kalmykov-2243762b1/)")
                                    
                                    Text("")
                                    
                                    Text("[Give us a Star ⭐️ on GitHub](https://github.com/frimoss/flexair-ios)")
                                }
                                .font(.system(size: 15))
                                .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                    .padding(.top, 20)
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
