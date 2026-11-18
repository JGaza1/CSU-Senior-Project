//
//  HealthKitManager.swift
//  Project Health
//
//  Created by Joseph Gaza on 9/21/26.
//

import Foundation
import HealthKit

final class HealthKitManager {
    
    // This is the connection to Apple Health
    let healthStore = HKHealthStore()
    
    // Health data that Project Health will read
    let steps = HKQuantityType(.stepCount)
    let activeEnergy = HKQuantityType(.activeEnergyBurned)
    let basalEnergy = HKQuantityType(.basalEnergyBurned)
    
    // Group the HealthKit Data
    var readData: Set<HKObjectType> {
        [
            steps,
            activeEnergy,
            basalEnergy
        ]
    }
    
    // This will check if HealthKit is available on the user's device
    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
        // This function will ask the user for permission to allow the app to read HealthKit data
        func requestHealthKitPermission() async -> Bool {
            
            // Checks that HealthKit is supported on the device
            guard isHealthDataAvailable
                    else {
                print("HealthKit is not available for this device.")
                return false
            }
            
            do {
                
                // FOR NOW ONLY READ HEALTH DATA
                try await healthStore.requestAuthorization(toShare: [], read: readData)
                
                print("HealthKit has successfully authorized the request.")
                return true
            } catch {
                
                print("HealthKit authorization has failed.")
                return false
            }
    }
    
    // Generic helper function to perform the HealthKit query for any type
    private func fetchHealthTotal (dataType: HKQuantityType, unit: HKUnit) async throws -> Double
    {
        // Get today's date
        let today = Date()
        
        // This will make it to where midnight means the beginning of the day
        let startDay = Calendar.current.startOfDay(for: today)
        
        // Only search HealthKit data from today
        let datePredicate = HKQuery.predicateForSamples(withStart: startDay, end: today)
        
        // Healthkit will know which type of data the user is searching for
        let samplePredicate = HKSamplePredicate.quantitySample(type: dataType, predicate: datePredicate)
        
        // This will add of today's HealthKit data together
        let todaysData = HKStatisticsQueryDescriptor(predicate: samplePredicate, options: .cumulativeSum)
        
        // Run todaysData
        let result = try await todaysData.result(for: healthStore)
        
        // Grab the total
        let total = result?
            .sumQuantity()?
            .doubleValue(for: unit)
        
        return total ?? 0
    }
    
    // Fetch today's steps
    func fetchTodaySteps() async throws -> Int
    {
        let total = try await fetchHealthTotal(dataType: steps, unit: .count())
        return Int(total.rounded())
    }
    
    // Fetch today's active calories
    func fetchTodayActiveCalories() async throws -> Double
    {
        let total = try await fetchHealthTotal(dataType: activeEnergy, unit: .largeCalorie())
        return total
    }
    
    // Fetch today's basal calories (Resting)
    func fetchTodayRestingCalories() async throws -> Double
    {
        let total = try await fetchHealthTotal(dataType: basalEnergy, unit: .largeCalorie())
        return total
    }
}
