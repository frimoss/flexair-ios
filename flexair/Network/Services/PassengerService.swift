//
//  PassengerService.swift
//  flexair
//
//  Created by Nikolai on 28/11/2025.
//

import Foundation

final class PassengerService {
    private let supabase = SupabaseManager.shared.supabase
    
    // MARK: Add new Passenger -> void
    /// Adds a new passenger to Database
    func addPassenger(
        userId: UUID,
        firstName: String,
        lastName: String,
        dateOfBirth: String,
        gender: String,
        nationality: String
    ) async throws {
        struct AddPassengerParams: Encodable {
            let p_user_id: String
            let p_first_name: String
            let p_last_name: String
            let p_date_of_birth: String
            let p_gender: String
            let p_nationality: String
        }
        
        // Convert Date to String format for Database
        let dobString = convertToAPI(dateOfBirth)
        
        let params = AddPassengerParams(
            p_user_id: userId.uuidString,
            p_first_name: firstName,
            p_last_name: lastName,
            p_date_of_birth: dobString,
            p_gender: gender,
            p_nationality: nationality
        )
        
        try await supabase
            .rpc("add_passenger", params: params)
            .execute()
            .value
    }
    
    
    // MARK: Fetch Passengers -> return [Passenger]
    /// Fetches all passengers for a given user
    func fetchPassengers(userId: UUID) async throws -> [Passenger] {
        let passengers: [Passenger] = try await supabase
          .from("passengers")
          .select()
          .eq("user_id", value: userId.uuidString) // Filter by User
          .execute()
          .value
        
        return passengers
    }
    
    
    // MARK: Update Passenger -> void
    /// Updates an existing passenger
    func updatePassenger(
        passengerId: Int,
        userId: UUID,
        firstName: String,
        lastName: String,
        dateOfBirth: String,
        gender: String,
        nationality: String
    ) async throws {
        struct UpdatePassengerParams: Encodable {
            let p_passenger_id: Int
            let p_user_id: String
            let p_first_name: String
            let p_last_name: String
            let p_date_of_birth: String
            let p_gender: String
            let p_nationality: String
        }
        
        // Convert Date to String format for Database
        let dobString = convertToAPI(dateOfBirth)
        
        let params = UpdatePassengerParams(
            p_passenger_id: passengerId,
            p_user_id: userId.uuidString,
            p_first_name: firstName,
            p_last_name: lastName,
            p_date_of_birth: dobString,
            p_gender: gender,
            p_nationality: nationality
        )
        
        try await supabase
            .rpc("update_passenger", params: params)
            .execute()
            .value
    }
    
    
    // MARK: - Convert to API format: String(DD.MM.YYYY) → YYYY-MM-DD
    
    private func convertToAPI(_ date: String) -> String {
        let digits = date.filter { $0.isNumber }
        
        guard digits.count == 8 else { return "" }
        
        let day = digits.prefix(2)
        let month = digits.dropFirst(2).prefix(2)
        let year = digits.suffix(4)
        
        return "\(year)-\(month)-\(day)"
    }
}
