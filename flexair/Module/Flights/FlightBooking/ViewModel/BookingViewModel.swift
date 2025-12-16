//
//  BookingViewModel.swift
//  flexair
//
//  Created by Nikolai on 27/11/2025.
//

import Foundation

@Observable
final class BookingViewModel {
   
    // MARK: - Dependencies
    private let authService: AuthService
    private let bookingService: BookingService
    
    // MARK: - State
    private(set) var userBookings: [UserBooking] = []
    private(set) var completedBooking: UserBooking? = nil
    
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    // MARK: - Initialization
    init(
        authService: AuthService = .shared,
        bookingService: BookingService = BookingService()
    ) {
        self.authService = authService
        self.bookingService = bookingService
    }
    
    // MARK: - Public Methods
    
    // MARK: Load User Bookings
    /// Loads all bookings for the current user
    func loadBookings() async {
        
        guard let userId = authService.currentUser?.id else {
            print("❌ Cannot get UserId - user not authenticated")
            errorMessage = "Please sign in to view bookings"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            userBookings = try await bookingService.getUserBookings(userId: userId)
            print("✅ Loaded \(userBookings.count) bookings")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Failed to load bookings: \(error)")
        }
        
        isLoading = false
    }
   
    // MARK: Create Booking
    /// Creates a new booking
    func createBooking(flightId: Int, passengerId: Int, totalPrice: Int) async throws {
        
        guard let userId = authService.currentUser?.id else {
            print("❌ Cannot get UserId - user not authenticated")
            throw AppError.notAuthenticated
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            completedBooking = try await bookingService.createBooking(
                userId: userId,
                flightId: flightId,
                passengerId: passengerId,
                totalPrice: totalPrice
            )
            
            print("✅ Booking created: \(completedBooking!)")
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("❌ Booking Failed: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: Cancel Booking
    /// Cancels an existing booking
    func cancelBooking(bookingId: Int) async throws {
        
        guard let userId = authService.currentUser?.id else {
            print("❌ Cannot get UserId - user not authenticated")
            throw AppError.notAuthenticated
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await bookingService.cancelBooking(
                bookingId: bookingId,
                userId: userId
            )
            
            print("✅ Booking cancelled: \(response)")
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("❌ Cancel Booking Failed: \(error)")
        }
        
        isLoading = false
    }
}
