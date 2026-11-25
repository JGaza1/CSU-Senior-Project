//
//  DashboardViewModel.swift
//  Project Health
//
//  Created by Joseph Gaza on 9/20/26.
//

import SwiftUI
import Combine
import Supabase
import Foundation


private nonisolated struct InsertedWeightLog: Decodable {
    let id: UUID
}

@MainActor
class DashboardViewModel: ObservableObject {
    
    // Dashboard Data
    
    // Connect HealthKitManager.swift
    private let healthKitManager = HealthKitManager()
    
    // Connect to food_logs in Supabase
    private let foodLogService = FoodLogService()
    
    @Published var username = ""
    @Published var age: Int?  // ? - Optional
    @Published var heightInches: Double?
    
    @Published var currentWeight: Double?
    private(set) var lastSavedWeightLogID: UUID?
    
    @Published var currentGoal: CurrentGoal?
    
    // Active weight-related goal
    @Published var weightGoal: CurrentGoal?

    // Active daily step goal
    @Published var stepGoal: CurrentGoal?
    
    // These are for later when Apple HealthKit gets integrated
    @Published var steps: Int?
    @Published var activeCalories: Double?
    @Published var restingCalories: Double?
    
    // Every time HealthKit Data is successfully saved to supabase, this variable will increase by one
    @Published private(set) var healthSaveRevision = 0

    
    // Total calories the user has eaten today
    @Published var caloriesConsumed: Double?
    
    // Calculates today's net calories
    var netCalories: Double? {
        
        guard let caloriesConsumed,
              let activeCalories,
              let restingCalories else {
            
            return nil
        }
        
        
        return caloriesConsumed -
            (restingCalories + activeCalories)
    }
    
    // Loading (Async work)
    @Published var isLoading = false
    
    // Error messaging
    @Published var errorMessage = ""
    
    // Loading the Dashboard
    
    func loadDashboard() async {
        errorMessage = ""
        isLoading = true
        
        guard let currentUserID = supabase.auth.currentUser?.id
                else {
            errorMessage = "Could not find User."
            isLoading = false
            return
        }
        
        
        
        do {
            // Getting from DatabaseModels.swift
            
            // Obtain username from Supabase (users Table)
            let users: [AppUser] = try await supabase
                .from("users")
                .select()
                .eq("id", value: currentUserID)
                .limit(1)
                .execute()
                .value
            
            username = users.first?.username ?? "User"
            
            // Obtain the Health Profile from Supabase (health_profiles)
            let healthProfiles: [HealthProfile] = try await supabase
                .from("health_profiles")
                .select()
                .eq("user_id", value: currentUserID)
                .limit(1)
                .execute()
                .value
            
            //
            if let profile = healthProfiles.first
            {
                age = profile.age
                heightInches = profile.height_inches
            }
                
            // Obtain weight from Supabse (weight_logs Table)
            let weights: [CurrentWeight] = try await supabase
                .from("weight_logs")
                .select("weight_lbs")
                .eq("user_id", value: currentUserID)
                .order("recorded_at", ascending: false)
                .limit(1)
                .execute()
                .value
            
            currentWeight = weights.first?.weight_lbs
            
            // Obtain the active goal from Supabase (goals Table)
            let goals: [CurrentGoal] = try await supabase
                .from("goals")
                .select("""
                        goal_type, starting_value, target_value, unit, status, target_date
                        """)
                .eq("user_id", value: currentUserID)
                .eq("status", value: "active")
                .order("created_at", ascending: false)
                .execute()
                .value
            
            // Find the newest active weight goal
            weightGoal = goals.first { goal in
                goal.unit == "lbs"
            }


            // Find the newest active step goal
            stepGoal = goals.first { goal in
                goal.goal_type == "increase_steps" &&
                goal.unit == "steps"
            }


            // Keep this temporarily while the Dashboard
            // is being changed to support both goals
            currentGoal = goals.first
            
            isLoading = false
            
        } catch is CancellationError {
            
            isLoading = false
            print("Dashboard loading was cancelled")
            
        } catch {
            
            isLoading = false
            errorMessage = error.localizedDescription // REMOVE LATER KEEP NOW FOR TESTING
            print("Dashboard has encountered an error: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: Update Weight
    // Updates the user's current weight
    // by adding a new row to weight_logs
    func updateWeight(_ newWeight: Double) async -> Bool {
        
        errorMessage = ""
        
        // Clear the previous saved weight ID
        lastSavedWeightLogID = nil
        
        
        // Make sure the weight is a usable number
        guard newWeight.isFinite,
              newWeight > 0 else {
            
            errorMessage = "Enter a valid weight."
            return false
        }
        
        
        // Make sure a user is logged in
        guard let currentUserID =
                supabase.auth.currentUser?.id else {
            
            errorMessage =
                "You must be logged in to update your weight."
            
            return false
        }
        
        
        // Create a new weight history entry
        let newWeightLog = NewWeightLog(
            user_id: currentUserID,
            weight_lbs: newWeight
        )
        
        
        do {
            
            // Save the weight and retrieve its generated ID
                let savedWeight: InsertedWeightLog = try await supabase
                    .from("weight_logs")
                    .insert(newWeightLog)
                    .select("id")
                    .single()
                    .execute()
                    .value
            
            // Remember the saved weight ID
            lastSavedWeightLogID = savedWeight.id
            
            
            // Immediately update the Dashboard
            currentWeight = newWeight
            
            // Refresh active goals after Supabase
            // checks whether a weight goal was completed.
            await loadDashboard()
            
            print(
                "Weight updated to \(newWeight) lbs."
            )
            
            return true
            
        } catch is CancellationError {
            
            print("Weight update was cancelled.")
            return false
            
        } catch {
            
            errorMessage = "Could not update weight."
            
            print(
                "Weight update failed: \(error.localizedDescription)"
            )
            
            return false
        }
    }
    
    // This function loads today's data from Apple Health
    func loadHealthData() async {
        
        // Ask HealthKit for authorization
        let authorizationCompleted =
            await healthKitManager.requestHealthKitPermission()
        
        guard authorizationCompleted else {
            
            print(
                "HealthKit authorization was not completed."
            )
            
            return
        }
        
        
        // Load the first set of HealthKit values
        await refreshHealthData()
    }
    
    // Refresh the latest Apple Health values
    func refreshHealthData() async {
        
        do {
            
            // Get the newest HealthKit values
            let newSteps =
                try await healthKitManager.fetchTodaySteps()
            
            let newActiveCalories =
                try await healthKitManager
                    .fetchTodayActiveCalories()
            
            let newRestingCalories =
                try await healthKitManager
                    .fetchTodayRestingCalories()
            
            
            // Check whether HealthKit actually changed
            let healthDataChanged =
                newSteps != steps ||
                newActiveCalories != activeCalories ||
                newRestingCalories != restingCalories
            
            
            // Update what the Dashboard displays
            steps = newSteps
            
            activeCalories =
                newActiveCalories
            
            restingCalories =
                newRestingCalories
            
            
            // Only update Supabase when something changed
            if healthDataChanged {
                
                await saveHealthData()
                
                print(
                    "HealthKit data changed and was refreshed."
                )
                
            } else {
                
                print(
                    "HealthKit data checked. No changes."
                )
            }
            
        } catch is CancellationError {
            
            print(
                "HealthKit refresh was cancelled."
            )
            
        } catch {
            
            print(
                "Error refreshing HealthKit data: \(error.localizedDescription)"
            )
        }
    }
    
    // Load today's total calories consumed
    func loadTodayCaloriesConsumed() async {
        
        do {
            
            // Get only today's food logs
            let todayFoodLogs =
                try await foodLogService.fetchTodayFoodLogs()
            
            
            // Add the calories from every food together
            caloriesConsumed =
                todayFoodLogs.reduce(0) { total, foodLog in
                    
                    total + foodLog.calories
                }
            
            
            print(
                "Today's calories consumed: \(caloriesConsumed?.formatted() ?? "--")"
            )
            
        } catch is CancellationError {
            
            print(
                "Loading today's calories consumed was cancelled."
            )
            
        } catch {
            
            caloriesConsumed = nil
            
            print(
                "Error loading today's calories consumed: \(error.localizedDescription)"
            )
        }
    }
    
    // This will save Apple Health data and connect to Supabase user
    func saveHealthData() async {
        
        // Retrieve the Supabase user's ID
        guard let currentUserID = supabase.auth.currentUser?.id
                else {
            print("Could not find the Supabase user.")
            return
        }
        
        // Makes sure the HealthKit data was loaded
        guard let steps,
              let activeCalories,
              let restingCalories
                else {
            print("HealthKit data is not being saved.")
            return
        }
        
        // Convert today's date into the same format as the stat_date column from the health_daily_stats table in Supabase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        
        let today = dateFormatter.string(from: Date())
        
        // Combine Supabase user with HealthKit Data
        let healthStat = HealthDailyStat(
            user_id: currentUserID,
            stat_date: today,
            steps: steps,
            active_calories: activeCalories,
            resting_calories: restingCalories
        )
        
        do {
            try await supabase
                .from("health_daily_stats")
                .upsert(
                    healthStat,
                    onConflict: "user_id,stat_date"
                )
                .execute()

            // Notify SwiftUI that HealthKit data was saved
            healthSaveRevision += 1

            print("Today's HealthKit data was saved to the Supabase database.")

        } catch is CancellationError {

            print("Saving HealthKit data was cancelled")

        } catch {

            print("Error saving HealthKit data: \(error.localizedDescription)")
        }

    }
    
    // Display the height
    
    var formatHeight: String {
        guard let heightInches
                else {
            return "--"
        }
        
        let totalInches = Int(heightInches.rounded())
        
        let feet = totalInches / 12
        let inches = totalInches % 12
        
        return "\(feet)'\(inches)\""
    }
    
    // Display the goal name
    
    var formatGoalName: String {
        guard let currentGoal
                else {
            return "No Active Goal"
        }
        
        switch currentGoal.goal_type
        {
            
        case "lose_weight":
            return "Lose Weight"
            
        case "gain_weight":
            return "Gain Weight"
            
        case "maintain_weight":
            return "Maintain Weight"
            
        case "increase_steps":
            return "Increase Daily Steps"
            
        default:
            return currentGoal.goal_type
            
        }
    }
    
    // Get the goal progress

    var goalProgress: Double {
        
        guard let goal = currentGoal else {
            return 0
        }
        
        
        // Daily step goal
        if goal.goal_type == "increase_steps",
           goal.unit == "steps" {
            
            guard let steps,
                  goal.target_value > 0 else {
                return 0
            }
            
            let progress =
                Double(steps) / goal.target_value
            
            // Prevent progress from going below 0
            // or above 100%
            return min(max(progress, 0), 1)
        }
        
        
        // Weight-based goals
        guard let currentWeight,
              goal.unit == "lbs" else {
            return 0
        }
        
        
        let totalChange =
            goal.target_value - goal.starting_value
        
        
        // Maintain weight
        if totalChange == 0 {
            return 0
        }
        
        
        let currentChange =
            currentWeight - goal.starting_value
        
        let progress =
            currentChange / totalChange
        
        
        // Prevent progress from going below 0
        // or above 100%
        return min(max(progress, 0), 1)
    }
    
    // Returns the display name for a specific goal
    func formatGoalName(
        for goal: CurrentGoal
    ) -> String {
        
        switch goal.goal_type {
            
        case "lose_weight":
            return "Lose Weight"
            
        case "gain_weight":
            return "Gain Weight"
            
        case "maintain_weight":
            return "Maintain Weight"
            
        case "increase_steps":
            return "Increase Daily Steps"
            
        default:
            return goal.goal_type
        }
    }
    
    // Calculates progress for a specific goal
    func goalProgress(
        for goal: CurrentGoal
    ) -> Double {
        
        
        // Daily step goal
        if goal.goal_type == "increase_steps",
           goal.unit == "steps" {
            
            guard let steps,
                  goal.target_value > 0 else {
                return 0
            }
            
            let progress =
                Double(steps) / goal.target_value
            
            return min(max(progress, 0), 1)
        }
        
        
        // Weight-based goals
        guard let currentWeight,
              goal.unit == "lbs" else {
            return 0
        }
        
        
        let totalChange =
            goal.target_value - goal.starting_value
        
        
        // Maintain Weight
        if totalChange == 0 {
            return 0
        }
        
        
        let currentChange =
            currentWeight - goal.starting_value
        
        let progress =
            currentChange / totalChange
        
        
        return min(max(progress, 0), 1)
    }
    
    // Saves a new goal while preserving the old goal in history
    func saveGoal(
        goalType: String,
        startingValue: Double,
        targetValue: Double,
        unit: String,
        targetDate: Date? = nil
    ) async -> Bool {

        
        errorMessage = ""
        
        
        guard let currentUserID =
                supabase.auth.currentUser?.id else {
            
            errorMessage = "Could not find user."
            return false
        }
        
        
        guard startingValue.isFinite,
              targetValue.isFinite,
              targetValue >= 0 else {
            
            errorMessage = "Invalid goal values."
            return false
        }
        
        
        // Prepare the optional goal completion date
        var formattedTargetDate: String? = nil

        if let targetDate {

            // Prevent selecting a date in the past
            let today = Calendar.current.startOfDay(for: Date())

            guard Calendar.current.startOfDay(for: targetDate) >= today else {

                errorMessage = "Target date cannot be in the past."
                return false
            }

            // Convert the date into yyyy-MM-dd for Supabase
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = .current

            formattedTargetDate = dateFormatter.string(from: targetDate)
        }

        
        
        let newGoal = NewGoal(
            user_id: currentUserID,
            goal_type: goalType,
            starting_value: startingValue,
            target_value: targetValue,
            unit: unit,
            target_date: formattedTargetDate
        )

        
        
        do {
            
            // Make the old goal of the same category inactive.
            //
            // "lbs" means a weight goal.
            // "steps" means a daily step goal.
            try await supabase
                .from("goals")
                .update([
                    "status": "inactive"
                ])
                .eq(
                    "user_id",
                    value: currentUserID
                )
                .eq(
                    "status",
                    value: "active"
                )
                .eq(
                    "unit",
                    value: unit
                )
                .execute()
            
            
            // Insert the new goal.
            // Supabase automatically gives it
            // status = "active".
            try await supabase
                .from("goals")
                .insert(newGoal)
                .execute()
            
            
            // Reload the Dashboard so the new
            // weightGoal or stepGoal appears.
            await loadDashboard()
            
            
            print("Goal saved successfully.")
            
            return true
            
            
        } catch is CancellationError {
            
            print("Goal update was cancelled.")
            return false
            
            
        } catch {
            
            errorMessage =
                "Could not save the goal."
            
            print(
                "Goal update failed: \(error.localizedDescription)"
            )
            
            return false
        }
    }
    
    
}

