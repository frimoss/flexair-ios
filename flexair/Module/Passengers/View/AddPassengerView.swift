//
//  AddPassengerView.swift
//  flexair
//
//  Created by Nikolai on 31/10/2025.
//

import SwiftUI

struct AddPassengerView: View {
    @State private var viewModel = PassengerViewModel()

    // MARK: - Public
    let passenger: Passenger?
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Private
    private var isEditMode: Bool {
        passenger != nil
    }
    
    @State private var selectedCountry: Country?
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var dateOfBirth = ""
    @State private var gender: String = "Male"
    @State private var nationality: String = ""
    
    init(passenger: Passenger? = nil) {
        self.passenger = passenger
        
        // Initialize @State properties
        _firstName = State(initialValue: passenger?.firstName ?? "")
        _lastName = State(initialValue: passenger?.lastName ?? "")
        _dateOfBirth = State(initialValue: passenger?.dob ?? "")
        _isGenderMale = State(initialValue: passenger?.gender == "Male")
        if let nationalityName = passenger?.nationality {
            _selectedCountry = State(initialValue: Country(id: nil, name: nationalityName))
        } else {
            _selectedCountry = State(initialValue: nil)
        }
    }
    
    // ✅ Create focused states
    @FocusState private var focusedField: Field?
    
    // ✅ Move focus to next field
    private func moveFocusToNext() {
        switch focusedField {
        case .firstName:
            focusedField = .lastName
        case .lastName:
            focusedField = .birthdate
        case .birthdate:
            focusedField = nil
        case .none:
            break
        }
    }

    // ✅ Move focus to previous field
    private func moveFocusToPrevious() {
        switch focusedField {
        case .firstName:
            break
        case .lastName:
            focusedField = .firstName
        case .birthdate:
            focusedField = .lastName
        case .none:
            break
        }
    }
    
    enum Field {
        case firstName
        case lastName
        case birthdate
    }
    
    private var isValidate: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !dateOfBirth.isEmpty &&
        !gender.isEmpty &&
        selectedCountry != nil
    }
    
    private var isEmpty: Bool {
        firstName.isEmpty &&
        lastName.isEmpty &&
        dateOfBirth.isEmpty &&
        selectedCountry == nil
    }
    
    // Flags
    @State private var showAlert = false
    @State private var showCountryPicker = false
    @State private var isGenderMale = true
    
    // Constants
    private enum MyConstants {
        case mySpacing, titleFontSize, fieldFontSize
        var value: CGFloat {
            switch self {
            case .mySpacing: return 6
            case .titleFontSize: return 15
            case .fieldFontSize: return 16
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 14) {
                        // FirstName
                        VStack(alignment: .leading, spacing: MyConstants.mySpacing.value) {
                            Text("First Name")
                                .font(.system(size: MyConstants.titleFontSize.value))
                                .padding(.leading, 12)
                            TextField("Given names", text: $firstName)
                                .font(.system(size: MyConstants.fieldFontSize.value))
                                .textFieldStyle(PrimaryTextFieldStyle())
                                .focused($focusedField, equals: .firstName)
                                .textContentType(.givenName)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .lastName
                                }
                        }
                        
                        // LastName
                        VStack(alignment: .leading, spacing: MyConstants.mySpacing.value) {
                            Text("Last Name")
                                .font(.system(size: MyConstants.titleFontSize.value))
                                .padding(.leading, 14)
                            TextField("Surname", text: $lastName)
                                .font(.system(size: MyConstants.fieldFontSize.value))
                                .textFieldStyle(PrimaryTextFieldStyle())
                                .focused($focusedField, equals: .lastName)
                                .textContentType(.familyName)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .birthdate
                                }
                        }
                        
                        // Date Of Birth
                        VStack(alignment: .leading, spacing: MyConstants.mySpacing.value) {
                            Text("Date of birth")
                                .font(.system(size: MyConstants.titleFontSize.value))
                                .padding(.leading, 12)
        
                            TextField("DD.MM.YYYY", text: $dateOfBirth)
                                .font(.system(size: MyConstants.fieldFontSize.value))
                                .textFieldStyle(PrimaryTextFieldStyle())
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .birthdate)
                                .onChange(of: dateOfBirth) { oldValue, newValue in
                                    dateOfBirth = formatBirthdate(newValue)
                                }
                        }
                        
                        // Gender
                        VStack(alignment: .leading, spacing: MyConstants.mySpacing.value) {
                            Text("Gender")
                                .font(.system(size: MyConstants.titleFontSize.value))
                                .padding(.leading, 12)
                            
                            HStack {
                                Button {
                                    isGenderMale = true
                                } label: {
                                    VStack {
                                        Text("Male")
                                            .font(.system(size: MyConstants.fieldFontSize.value))
                                            .frame(maxHeight: .infinity)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                isGenderMale
                                                ? Constants.Colors.backgroundApp
                                                : Constants.Colors.background
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    isGenderMale = false
                                } label: {
                                    VStack {
                                        Text("Female")
                                            .font(.system(size: MyConstants.fieldFontSize.value))
                                            .frame(maxHeight: .infinity)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                isGenderMale
                                                ? Constants.Colors.background
                                                : Constants.Colors.backgroundApp
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                    }
                                }
                            }
                            .padding(6)
                            .frame(height: Constants.UI.height)
                            .foregroundStyle(Constants.Colors.textPrimary)
                            .background(Constants.Colors.background)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
                        }
                        
                        // Nationality
                        VStack(alignment: .leading, spacing: MyConstants.mySpacing.value) {
                            Text("Nationality")
                                .font(.system(size: MyConstants.titleFontSize.value))
                                .padding(.leading, 12)
                                
                            Button {
                                showCountryPicker = true
                            } label: {
                                HStack {
                                    Text(selectedCountry == nil
                                         ? "Select country"
                                         : selectedCountry?.name ?? ""
                                    )
                                    .font(.system(size: MyConstants.fieldFontSize.value))
                                    .opacity(
                                        selectedCountry == nil
                                        ? 0.3
                                        : 1
                                    )
                                    
                                    Spacer()
                                }
                                .padding(.horizontal) // Internal padding
                                .frame(height: Constants.UI.height)
                                .foregroundStyle(Constants.Colors.textPrimary)
                                .background(Constants.Colors.background)
                                .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
                            }
                        }
                    }
                }
                .foregroundStyle(Constants.Colors.textPrimary)
                .frame(maxHeight: .infinity)
                .padding()
            }
            .background(Constants.Colors.backgroundApp)
            .navigationTitle(isEditMode ? "Edit Passenger" : "New Passenger")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .sheet(isPresented: $showCountryPicker) {
                CountryPickerView(selectedCountry: $selectedCountry)
            }
            .alert("Discard Changes?", isPresented: $showAlert) {
                Button("Keep Editing", role: .cancel) {
                    // stay on the screen
                }
                Button("Discard Changes", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("You have unsaved Passenger information. If you go back now, your changes will be lost.")
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    // ✅ Previous button
                    Button {
                        moveFocusToPrevious()
                    } label: {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(focusedField == .firstName)
                    
                    // ✅ Next button
                    Button {
                        moveFocusToNext()
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(focusedField == .birthdate)
                    
                    Spacer()
                    
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        if isEmpty || isEditMode {
                            dismiss()
                        } else {
                            showAlert = true
                        }
                    } label: {
                        Image(systemName: "chevron.backward")
                            .fontWeight(.semibold)
                        Text("Back")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Gender
                        if isGenderMale {
                            gender = "Male"
                        } else {
                            gender = "Female"
                        }
                        
                        // Nationality
                        if let selectedCountry {
                            nationality = selectedCountry.name
                        }
                        
                        if !isValidate {
                            return
                        }

                        print("firstName: \(firstName)")
                        print("lastName: \(lastName)")
                        print("dateOfBirth: \(dateOfBirth)")
                        print("gender: \(gender)")
                        print("nationality: \(nationality)")
                        
                        Task {
                            if isEditMode, let passenger {
                                try await viewModel.updatePassenger(
                                    passengerId: passenger.id,
                                    firstName: firstName,
                                    lastName: lastName,
                                    dateOfBirth: dateOfBirth,
                                    gender: gender,
                                    nationality: nationality
                                )
                            } else {
                                try await viewModel.addPassenger(
                                    firstName: firstName,
                                    lastName: lastName,
                                    dateOfBirth: dateOfBirth,
                                    gender: gender,
                                    nationality: nationality
                                )
                            }
                            dismiss()
                        }
                    }
                    .disabled(!isValidate)
                }
            }
        }
    }
}

#Preview {
    AddPassengerView()
}


// MARK: Format User's Input with Dots: "DD.MM.YYYY"
private func formatBirthdate(_ input: String) -> String {
    let digits = input.filter { $0.isNumber }
    let limited = String(digits.prefix(8))
    
    var formatted = ""
    for (index, char) in limited.enumerated() {
        if index == 2 || index == 4 {
            formatted += "."
        }
        formatted.append(char)
    }
    return formatted
}

