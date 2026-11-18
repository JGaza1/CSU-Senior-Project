//
//  UserInfoView.swift
//  Project Health
//
//  Created by Joseph Gaza on 9/1/26.
//


import SwiftUI

struct UserInfoView: View {
    // Connects to the Account.swift file in order to save the data
    @ObservedObject private var connectAccount: Account
    
    // Initializer so preview can be shown
    init(connectAccount: Account) {
        self.connectAccount = connectAccount
    }
    
    // User info variables
    @State private var age = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var biologicalSex = "Male" // default
    
    // Variables for the user's goals
    @State private var goalType = "Lose Weight" // default
    @State private var targetAmount = ""
    
    // Options for the sex and goals
    let sexOptions = ["Male", "Female"]
    let goalOptions = [
        "Lose Weight",
        "Maintain Weight",
        "Gain Weight",
        "Increase Steps"
    ]
    
    // This variable is for error messaging for validateInput()
    @State private var errorMessage = ""
    
    var body: some View {
            Form {
                
                // This section is for the biological data
                Section(header: Text("Personal Info")) {
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    
                    // Sex
                    Picker("Biological Sex", selection: $biologicalSex) {
                        ForEach(sexOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    
                    // Weight
                    TextField("Weight (lbs)", text: $weight)
                        .keyboardType(.decimalPad)
                    
                    // Height
                    TextField("Height (inches)", text: $height)
                        .keyboardType(.decimalPad)
                }
                
                // This section is for the user's health goals
                Section(header: Text("Health Goal"), footer: Text("This will help use calculate your daily caloric needs.")) {
                    Picker("Goal Type", selection: $goalType) {
                        ForEach(goalOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // This will only show the target amount field if they are trying to lose or gain weight
                    if goalType == "Lose Weight" {
                        
                        HStack {
                            
                            Text("Target Loss:")
                            
                            TextField(
                                "e.g. 10",
                                text: $targetAmount
                            )
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            
                            Text("lbs")
                                .foregroundColor(.secondary)
                        }
                        
                    } else if goalType == "Gain Weight" {
                        
                        HStack {
                            
                            Text("Target Gain:")
                            
                            TextField(
                                "e.g. 10",
                                text: $targetAmount
                            )
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            
                            Text("lbs")
                                .foregroundColor(.secondary)
                        }
                        
                    } else if goalType == "Increase Steps" {
                        
                        HStack {
                            
                            Text("Daily Step Goal:")
                            
                            TextField(
                                "e.g. 10000",
                                text: $targetAmount
                            )
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            
                            Text("steps")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // This section is for error handling
                // Also includes save button
                Section {
                    if (!errorMessage.isEmpty)
                    {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    if (!connectAccount.errorMessage.isEmpty)
                    {
                        Text(connectAccount.errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    // Button
                    Button(action: {
                            // Once the button is clicked save, validate input, then saveOnboardingDetails
                            validateInput()
                            
                        
                    }) {
                        HStack {
                            Spacer()
                            if connectAccount.isLoading {
                                ProgressView()
                            } else {
                                Text("Save and Continue")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(connectAccount.isLoading) // this will prevent double-tapping
                }
            }
            .navigationTitle("Welcome To Project Health")
            // This will prevent the user from swiping back to the login screen
            .navigationBarBackButtonHidden(true)
        }
    
    // This private function will validate user input before calling saveOnboardingDetails function within Account.swift
    private func validateInput() {
        
        errorMessage = ""
        
        // Check required fields
        if age.isEmpty || weight.isEmpty || height.isEmpty {
            errorMessage = "Please fill in all the fields."
            return
        }
        
        // Convert age
        guard let userAge = Int(age) else {
            errorMessage = "Please enter a valid age."
            return
        }
        
        // Check for age
        if userAge <= 0
        {
            errorMessage = "Please enter a valid age."
            return
        }
        
        // Convert weight
        guard let userWeight = Double(weight) else {
            errorMessage = "Please enter a valid weight."
            return
        }
        
        // Checks if weight is 0 or less
        if userWeight <= 0 {
            errorMessage = "Weight must be greater than 0."
            return
        }
        
        // Convert height
        guard let userHeight = Double(height) else {
            errorMessage = "Please enter a valid height in inches."
            return
        }
        
        // Height must be positive
        if userHeight <= 0 {
            errorMessage = "Height must be greater than 0."
            return
        }
        
        let databaseGoalType: String
        let startingGoalValue: Double
        let finalTargetValue: Double
        let goalUnit: String
        
        switch goalType {
            
        case "Lose Weight":
            
            guard let amount = Double(targetAmount) else {
                errorMessage = "Please enter a valid target loss."
                return
            }
            
            if amount <= 0 {
                errorMessage = "Target loss must be greater than 0."
                return
            }
            
            let targetWeight = userWeight - amount
            
            if targetWeight <= 0 {
                errorMessage = "Target weight must be greater than 0."
                return
            }
            
            databaseGoalType = "lose_weight"
            startingGoalValue = userWeight
            finalTargetValue = targetWeight
            goalUnit = "lbs"
            
            
        case "Gain Weight":
            
            guard let amount = Double(targetAmount) else {
                errorMessage = "Please enter a valid target gain."
                return
            }
            
            if amount <= 0 {
                errorMessage = "Target gain must be greater than 0."
                return
            }
            
            databaseGoalType = "gain_weight"
            startingGoalValue = userWeight
            finalTargetValue = userWeight + amount
            goalUnit = "lbs"
            
            
        case "Maintain Weight":
            
            databaseGoalType = "maintain_weight"
            startingGoalValue = userWeight
            finalTargetValue = userWeight
            goalUnit = "lbs"
            
            
        case "Increase Steps":
            
            guard let stepGoal = Int(targetAmount) else {
                errorMessage = "Please enter a valid daily step goal."
                return
            }
            
            if stepGoal <= 0 {
                errorMessage = "Daily step goal must be greater than 0."
                return
            }
            
            databaseGoalType = "increase_steps"
            startingGoalValue = 0
            finalTargetValue = Double(stepGoal)
            goalUnit = "steps"
            
            
        default:
            
            errorMessage = "Invalid goal."
            return
        }
        
        Task {
            await connectAccount.saveOnboardingDetails(
                age: userAge,
                weight: userWeight,
                heightInches: userHeight,
                sex: biologicalSex,
                goalType: databaseGoalType,
                startingValue: startingGoalValue,
                targetValue: finalTargetValue,
                goalUnit: goalUnit
            )
        }
    }
    
}

//#Preview {
//    UserInfoView(connectAccount: Account())
//}
