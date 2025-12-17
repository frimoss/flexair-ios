//
//  PassengerViewModel.swift
//  flexair
//
//  Created by Nikolai on 28/11/2025.
//

import Foundation

@Observable
final class PassengerViewModel {

    // MARK: - Dependencies
    private let authService: AuthService
    private let passengerService: PassengerService
    
    // MARK: - State
    private(set) var passengers: [Passenger] = []
    
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    // MARK: - Initialization
    /// Initialize with dependencies (allows testing with mock services)
    init(
        authService: AuthService = .shared,
        passengerService: PassengerService = PassengerService()
    ) {
        self.authService = authService
        self.passengerService = passengerService
    }
    
    // MARK: - Public Methods
    
    // MARK: - Load Passengers
    /// Loads all passengers for the current user
    func loadPassengers() async {
        
        guard let userId = authService.currentUser?.id else {
            errorMessage = "Please sign in to view passengers"
            print("❌ Cannot get UserId - user not authenticated")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            passengers = try await passengerService.fetchPassengers(userId: userId)
            print("✅ Loaded \(passengers.count) passengers")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Failed to load passengers: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Add Passenger
    /// Adds a new passenger
    func addPassenger(
        firstName: String,
        lastName: String,
        dateOfBirth: String,
        gender: String,
        nationality: String
    ) async throws {
        
        guard let userId = authService.currentUser?.id else {
            print("❌ Cannot get UserId - User not logged in")
            throw AppError.notAuthenticated
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await passengerService.addPassenger(
                userId: userId,
                firstName: firstName,
                lastName: lastName,
                dateOfBirth: dateOfBirth,
                gender: gender,
                nationality: nationality
            )
            print("✅ Passenger added: \(firstName) \(lastName)")
            
            // MARK: - Refresh the list after adding TODO ??
            // await loadPassengers()
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("❌ Add Passenger Failed: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Update Passenger
    /// Updates an existing passenger
    func updatePassenger(
        passengerId: Int,
        firstName: String,
        lastName: String,
        dateOfBirth: String,
        gender: String,
        nationality: String
    ) async throws {
        
        guard let userId = authService.currentUser?.id else {
            print("❌ Cannot get UserId - user not authenticated")
            throw AppError.notAuthenticated
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await passengerService.updatePassenger(
                passengerId: passengerId,
                userId: userId,
                firstName: firstName,
                lastName: lastName,
                dateOfBirth: dateOfBirth,
                gender: gender,
                nationality: nationality
            )
            
            print("✅ Passenger updated: \(firstName) \(lastName)")
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("❌ Update Passenger Failed: \(error)")
        }
        
        isLoading = false
    }
}
