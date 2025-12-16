//
//  AuthService.swift
//  flexair
//
//  Created by Nikolai on 27/11/2025.
//

import Foundation
import Supabase

@Observable
final class AuthService {
    static let shared = AuthService() // MARK: Singleton Pattern (one user session across app)
        
    // MARK: - Published State
    private(set) var currentUser: User?
    private(set) var isAuthenticated = false
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    private let supabase = SupabaseManager.shared.supabase
    
    // MARK: - Initialization
    private init() {
        // Check if user has an active session on app launch
        Task { await checkSession() }
    }
    
    // MARK: - Session Management
    /// Checks if user has a valid session (called on app launch)
    func checkSession() async {
        do {
            let session = try await supabase.auth.session
            
            await MainActor.run {
                self.currentUser = session.user
                self.isAuthenticated = true
            }
            
            print("✅ Session restored for user: \(session.user.email ?? "Unknown")")
        } catch {
            await MainActor.run {
                self.isAuthenticated = false
            }
            print("ℹ️ No active session found")
        }
    }
    
    // MARK: - Authentication Methods
    
    // MARK: Sign in with (Email and Password)
    /// Sign in with email and password
    func signIn(email: String, password: String) async throws {
        
        await MainActor.run { isLoading = true }
        
        do {
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            await MainActor.run {
                self.currentUser = session.user
                self.isAuthenticated = true
                self.errorMessage = nil
                self.isLoading = false
            }
            
            print("✅ User signed in: \(email)")
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            print("❌ Sign in failed: \(error)")
            throw error
        }
    }
    
    // MARK: Sign up as New user
    /// Sign up a new user
    func signUp(email: String, password: String) async throws {
        
        await MainActor.run { isLoading = true }
        
        do {
            let session = try await supabase.auth.signUp(
                email: email,
                password: password
            )
            
            await MainActor.run {
                self.currentUser = session.user
                self.errorMessage = nil
                self.isLoading = false
            }
            
            print("✅ User signed up: \(email)")
            
            // Sign In
            try await signIn(email: email, password: password)
            
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            print("❌ Sign up failed: \(error)")
            throw error
        }
    }
    
    // MARK: Sign out
    /// Sign out
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            
            await MainActor.run {
                self.currentUser = nil
                self.isAuthenticated = false
            }
            print("✅ User signed out")
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            print("❌ Sign out failed: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    /// Get user profile data
    func getUserProfile() -> UserProfile? {
        guard let user = currentUser else { return nil }
        
        return UserProfile(
            id: user.id,
            email: user.email,
            createdAt: user.createdAt
        )
    }
}
