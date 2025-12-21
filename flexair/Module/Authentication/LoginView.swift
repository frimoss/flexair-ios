//
//  LoginView.swift
//  testSupabase
//
//  Created by user on 27/11/2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) private var appState
    @State private var authService = AuthService.shared
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    // ✅ Create focused states
    @FocusState private var focusedField: Field?
    enum Field {
        case email
        case password
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo or Title
                HStack(alignment: .center, spacing: 4) {
                    Text("Flexair")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Image(systemName: "airplane")
                        .font(.system(size: 24))
                        .foregroundStyle(Constants.Colors.accent)
                }
                .padding(.vertical, 40)
                
                // Email Field
                TextField("Email", text: $email)
                    .textFieldStyle(PrimaryTextFieldStyle())
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password // Move to next field
                    }
                
                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(PrimaryTextFieldStyle())
                    .textContentType(isSignUp ? .newPassword : .password)
                    .submitLabel(.done)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        focusedField = nil // Close keyboard
                        Task {
                            try await auth()
                        }
                    }
                
                // Error Message
                if let error = authService.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                // Action Button
                Button(action: {
                    Task {
                        try await auth()
                    }
                }) {
                    if authService.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text(isSignUp ? "Sign Up" : "Sign In")
                            .fontWeight(.semibold)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(authService.isLoading || email.isEmpty || password.isEmpty)
                
                // Toggle Sign Up / Sign In
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .background(Constants.Colors.backgroundApp)
        }
    }
    
    private func auth() async throws {
        if isSignUp {
            try await authService.signUp(email: email, password: password)
        } else {
            try await authService.signIn(email: email, password: password)
        }
        // Update Auth State
        appState.updateState()
    }
}

#Preview {
    LoginView()
}
