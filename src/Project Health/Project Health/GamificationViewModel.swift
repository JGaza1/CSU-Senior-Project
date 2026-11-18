//
//  GamificationViewModel.swift
//  Project Health
//
//  Provides the dashboard with verified XP and fragment balances.
//

import Foundation
import Combine
import Supabase

@MainActor
final class GamificationViewModel: ObservableObject {
    private let service = GamificationService()

    @Published private(set) var totalXP: Int64 = 0
    @Published private(set) var craftingFragments: Int64 = 0
    
    @Published private(set) var weeklyChallengeProgress:
    WeeklyChallengeProgressResponse?

    @Published private(set) var unopenedRarePacks: Int64 = 0
    
    @Published private(set) var unopenedRarePackItems: [UnopenedRarePack] = []
    @Published private(set) var materialsInventory: [MaterialInventoryItem] = []
    
    @Published private(set) var isLoading = false
    @Published private(set) var hasLoaded = false
    @Published private(set) var rewardNotice: String?
    @Published private(set) var errorMessage: String?
    
    
    // MARK: - Achievements

    @Published private(set) var achievements: [AchievementProgressResponse] = []

    @Published private(set) var isClaimingAchievements = false
    
    
    // MARK: - Featured Achievements

    @Published private(set) var featuredAchievements: [FeaturedAchievementSelection] = []

    @Published private(set) var isSavingFeaturedAchievements = false

    @Published private(set) var featuredAchievementsError: String?
    
    
    // MARK: - Cosmetic Crafting

    @Published private(set) var cosmeticCatalog: [CosmeticDefinition] = []

    @Published private(set) var cosmeticRecipes: [CosmeticRecipeIngredient] = []

    @Published private(set) var ownedCosmetics: [OwnedCosmetic] = []

    @Published private(set) var isLoadingCosmetics = false

    @Published private(set) var isCraftingCosmetic = false

    @Published private(set) var cosmeticNotice: String?

    @Published private(set) var cosmeticError: String?
    
    
    // MARK: - Cosmetic Equipment

    @Published private(set) var equippedCosmetics: [EquippedCosmetic] = []

    @Published private(set) var isChangingEquipment = false

    @Published private(set) var cosmeticEquipmentNotice: String?

    @Published private(set) var cosmeticEquipmentError: String?


    
    
    // MARK: - Achievement Banner

    @Published private(set) var achievementBannerMessage: String?


    // With Level 1 -> Level 2 at 100 XP, each following level
    // requires 50 more XP than the previous one.
    private var levelState: (level: Int, earned: Int64, needed: Int64) {
        var xpRemaining = totalXP
        var requiredXP: Int64 = 100
        var currentLevel = 1

        while xpRemaining >= requiredXP {
            xpRemaining -= requiredXP
            currentLevel += 1
            requiredXP += 50
        }

        return (currentLevel, xpRemaining, requiredXP)
    }

    var level: Int { levelState.level }
    var xpInLevel: Int64 { levelState.earned }
    var xpNeededForLevel: Int64 { levelState.needed }
    var levelProgress: Double {
        let current = levelState
        return Double(current.earned) / Double(current.needed)
    }

    // Called when Dashboard first appears and when the app is foregrounded.
    func activateAndClaimDailyLogin() async {
        // Never initiate a claim while signed out.
        guard supabase.auth.currentUser != nil else {
            errorMessage = "Sign in to view your rewards."
            return
        }

        // Avoid overlapping requests from task / refresh / foreground events.
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        rewardNotice = nil
        defer { isLoading = false }

        do {
            let activation = try await service.activateGamification()
            try Task.checkCancellation()
            let dailyLogin = try await service.claimDailyLogin()
            try Task.checkCancellation()

            // Use server-returned balances, not local guesses.
            totalXP = dailyLogin.total_xp
            craftingFragments = dailyLogin.crafting_fragments
            hasLoaded = true

            var messages: [String] = []
            if activation.awarded {
                messages.append("Welcome reward: +25 XP, +10 fragments")
            }
            if dailyLogin.awarded {
                messages.append("Daily visit: +5 XP, +2 fragments")
            }
            rewardNotice = messages.isEmpty ? nil : messages.joined(separator: "\n")
            
            // MARK: - Automatic Achievement Check

            // Check for any achievements earned from
            // previously completed activities.
            await claimEarnedAchievements()

        } catch is CancellationError {
            // The dashboard was dismissed; do not display a false error.
        } catch {
            errorMessage = "Couldn't load rewards. You can retry below."
            print("Gamification reward error: \(error.localizedDescription)")
        }
    }
    
    
    
    // MARK: - Daily Step Goal Reward

    func claimStepGoalReward() async {

        // Make sure the user is logged in
        guard supabase.auth.currentUser != nil else {
            return
        }

        // Wait until the initial rewards have loaded
        guard hasLoaded, !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {

            // Ask Supabase to check today's step goal
            let result = try await service.claimStepGoal()

            try Task.checkCancellation()

            // Update the balances using Supabase's values
            totalXP = result.total_xp
            craftingFragments = result.crafting_fragments

            errorMessage = nil

            // Show a message only when a new reward is earned
            if result.awarded {

                rewardNotice =
                    "Daily step goal: +25 XP, +10 Crafting Fragments"

                // NEW: Check for unlocked step achievements
                await claimEarnedAchievements()
            }

        } catch is CancellationError {

            print("Step goal reward check was cancelled.")

        } catch {

            print(
                "Step goal reward error: \(error.localizedDescription)"
            )
        }
    }

    
    // MARK: - Weekly Weight Check-in Reward

        func claimWeightCheckinReward(weightLogID: UUID) async {

            guard supabase.auth.currentUser != nil else {
                return
            }

            do {

                // Ask Supabase whether this check-in earns a reward
                let result = try await service.claimWeightCheckin(
                    weightLogID: weightLogID
                )

                try Task.checkCancellation()

                // Use the verified balances from Supabase
                totalXP = result.total_xp
                craftingFragments = result.crafting_fragments
                hasLoaded = true

                if result.awarded {

                    rewardNotice =
                        "Weekly weight check-in: +15 XP, +5 Crafting Fragments"
                    
                    // Check for unlocked achievements
                                        await claimEarnedAchievements()
                }

                errorMessage = nil

            } catch is CancellationError {

                print("Weight reward check was cancelled.")

            } catch {

                errorMessage =
                    "Weight saved, but the weekly reward check failed."

                print(
                    "Weight reward error: \(error.localizedDescription)"
                )
            }
        }

    // MARK: - Refresh Weekly Challenge

    func refreshWeeklyChallengeProgress() async {

        guard supabase.auth.currentUser != nil else {
            return
        }

        do {

            let result = try await service
                .fetchWeeklyChallengeProgress()

            try Task.checkCancellation()

            weeklyChallengeProgress = result
            unopenedRarePacks = result.unopened_rare_packs

        } catch is CancellationError {

            print("Weekly challenge refresh cancelled.")

        } catch {

            errorMessage = "Could not load weekly challenge progress."

            print(
                "Weekly challenge error: \(error.localizedDescription)"
            )
        }
    }

    
    // MARK: - Claim Weekly Challenge Reward

    func claimWeeklyChallengeReward() async {

        guard supabase.auth.currentUser != nil else {
            return
        }

        do {

            // Ask Supabase to claim the weekly challenge
            let result = try await service.claimWeeklyChallenge()

            try Task.checkCancellation()

            // Update XP using Supabase's verified balance
            totalXP = result.total_xp

            // Update unopened rare packs
            unopenedRarePacks = result.unopened_rare_packs

            // Clear any previous error
            errorMessage = nil

            if result.awarded {

                rewardNotice =
                    "Weekly challenge complete: +50 XP and 1 Rare Crystal Pack!"
            }

            // Refresh the progress display
            await refreshWeeklyChallengeProgress()

            // Refresh inventory after claiming a reward
            await refreshUnopenedRarePacks()

            // Check for Weekly Challenge achievements
            if result.awarded {

                await claimEarnedAchievements()
            }

        } catch is CancellationError {

            print("Weekly reward claim cancelled.")

        } catch {

            errorMessage = "Could not claim weekly challenge reward."

            print(
                "Weekly reward error: \(error.localizedDescription)"
            )
        }
    }

    
    // MARK: - Refresh Rare Pack Inventory

        func refreshUnopenedRarePacks() async {

            // Make sure the user is signed in
            guard supabase.auth.currentUser != nil else {
                unopenedRarePackItems = []
                unopenedRarePacks = 0
                return
            }

            do {

                // Fetch the player's unopened packs
                let packs = try await service.fetchUnopenedRarePacks()

                try Task.checkCancellation()

                // Store the packs
                unopenedRarePackItems = packs

                // Update the number of unopened packs
                unopenedRarePacks = Int64(packs.count)

            } catch is CancellationError {

                print("Rare pack inventory refresh cancelled.")

            } catch {

                errorMessage = "Could not load your Rare Pack Inventory."

                print(
                    "Rare pack inventory error: \(error.localizedDescription)"
                )
            }
        }

    // MARK: - Refresh Materials Inventory

        func refreshMaterialsInventory() async {

            guard supabase.auth.currentUser != nil else {
                materialsInventory = []
                return
            }

            do {

                // Retrieve all material types and their balances
                let materials = try await service.fetchMaterialsInventory()

                try Task.checkCancellation()

                // Update the Materials Inventory
                materialsInventory = materials

            } catch is CancellationError {

                print("Materials inventory refresh cancelled.")

            } catch {

                errorMessage = "Could not load materials inventory."

                print(
                    "Materials inventory error: \(error.localizedDescription)"
                )
            }
        }

    
    // MARK: - Refresh Achievement Progress

    func refreshAchievementProgress() async {

        guard supabase.auth.currentUser != nil else {
            achievements = []
            return
        }

        do {

            // Retrieve all achievements and their progress
            let results = try await service.fetchAchievementProgress()

            try Task.checkCancellation()

            // Update achievements displayed in SwiftUI
            achievements = results

        } catch is CancellationError {

            print("Achievement progress refresh cancelled.")

        } catch {

            errorMessage = "Could not load achievement progress."

            print(
                "Achievement progress error: \(error.localizedDescription)"
            )
        }
    }
    
    // MARK: - Claim Earned Achievements

    func claimEarnedAchievements() async {

        guard supabase.auth.currentUser != nil else {
            return
        }

        guard !isClaimingAchievements else {
            return
        }

        isClaimingAchievements = true

        defer {
            isClaimingAchievements = false
        }

        do {

            // Ask Supabase to unlock eligible achievements
            let result = try await service.claimAchievements()

            try Task.checkCancellation()

            // Update XP and Crafting Fragments
            totalXP = result.total_xp
            craftingFragments = result.crafting_fragments

            // Refresh achievement unlock statuses
            await refreshAchievementProgress()
            
            // MARK: - Achievement Unlock Notification

            // Show a message if achievements were unlocked
            if result.newly_unlocked > 0 {

                // Find the newly unlocked achievements
                let unlockedAchievements = result.unlocked_codes.compactMap { code in

                    achievements.first { achievement in
                        achievement.code == code
                    }
                }

                // Include each achievement's tier and name
                let achievementNames = unlockedAchievements.map { achievement in

                    "\(achievement.tier.capitalized) - \(achievement.title)"
                }

                // Create the notification message
                let message = achievementNames.isEmpty
                    ? "Unlocked \(result.newly_unlocked) achievement(s)!"
                    : achievementNames.joined(separator: "\n")

                rewardNotice =
                    "🏅 Achievement Unlocked!\n" +
                    message + "\n" +
                    "+\(result.xp_awarded) XP and " +
                    "+\(result.fragments_awarded) Crafting Fragments"
                
                // Display this message in the Dashboard banner
                achievementBannerMessage = rewardNotice
            }


        } catch is CancellationError {

            print("Achievement claim cancelled.")

        } catch {

            errorMessage = "Could not claim achievements."

            print(
                "Achievement claim error: \(error.localizedDescription)"
            )
        }
    }

    
    // MARK: - Display Food Achievement Unlocks

    func presentFoodAchievementUnlock(
        _ result: AchievementClaimResponse
    ) async {

        guard result.newly_unlocked > 0 else {
            return
        }

        // Load the newest achievement details from Supabase
        await refreshAchievementProgress()

        // Match returned codes to achievement names and tiers
        let names = result.unlocked_codes.compactMap { code in

            achievements.first { achievement in
                achievement.code == code
            }
        }
        .map { achievement in

            "\(achievement.tier.capitalized) - \(achievement.title)"
        }

        let achievementText = names.isEmpty
            ? "Unlocked \(result.newly_unlocked) achievement(s)!"
            : names.joined(separator: "\n")

        // Build the banner message
        let message =
            "🏅 Achievement Unlocked!\n" +
            achievementText + "\n" +
            "+\(result.xp_awarded) XP and " +
            "+\(result.fragments_awarded) Crafting Fragments"

        rewardNotice = message
        achievementBannerMessage = message
    }

    
    // MARK: - Dismiss Achievement Banner

    func dismissAchievementBanner() {

        achievementBannerMessage = nil
    }

    
    // MARK: - Refresh Featured Achievements

    func refreshFeaturedAchievements() async {

        guard supabase.auth.currentUser != nil else {
            featuredAchievements = []
            featuredAchievementsError = nil
            return
        }

        do {

            // Get the player's featured badges from Supabase
            let featured = try await service.fetchFeaturedAchievements()

            try Task.checkCancellation()

            // Update the stored selections
            featuredAchievements = featured
            featuredAchievementsError = nil

        } catch is CancellationError {

            print("Featured achievements refresh cancelled.")

        } catch {

            featuredAchievementsError =
                "Could not load featured achievements."

            print(
                "Featured achievements error: \(error.localizedDescription)"
            )
        }
    }

    
    // MARK: - Save Featured Achievements

    func saveFeaturedAchievements(
        _ achievementIDs: [UUID]
    ) async -> Bool {

        // Make sure the player is signed in
        guard supabase.auth.currentUser != nil else {

            featuredAchievementsError = "Sign in to select achievements."
            return false
        }

        // Prevent overlapping save requests
        guard !isSavingFeaturedAchievements else {
            return false
        }

        // Allow no more than three badges
        guard achievementIDs.count <= 3 else {

            featuredAchievementsError =
                "You can only feature up to 3 achievements."

            return false
        }

        // Prevent selecting the same achievement twice
        guard Set(achievementIDs).count == achievementIDs.count else {

            featuredAchievementsError =
                "You cannot feature the same achievement twice."

            return false
        }

        isSavingFeaturedAchievements = true
        featuredAchievementsError = nil

        defer {
            isSavingFeaturedAchievements = false
        }

        do {

            // Save the selected badges to Supabase
            let saved = try await service.saveFeaturedAchievements(
                achievementIDs
            )

            try Task.checkCancellation()

            // Update the stored selections
            featuredAchievements = saved

            return true

        } catch is CancellationError {

            print("Saving featured achievements was cancelled.")
            return false

        } catch {

            featuredAchievementsError =
                "Could not save featured achievements."

            print(
                "Save featured achievements error: \(error.localizedDescription)"
            )

            return false
        }
    }

    
    // MARK: - Refresh Cosmetic Crafting Data

    func refreshCosmeticData() async {

        guard supabase.auth.currentUser != nil else {

            cosmeticCatalog = []
            cosmeticRecipes = []
            ownedCosmetics = []
            materialsInventory = []
            equippedCosmetics = []

            cosmeticError = nil
            return
        }

        guard !isLoadingCosmetics else {
            return
        }

        isLoadingCosmetics = true

        defer {
            isLoadingCosmetics = false
        }

        do {

            // Step 1: Retrieve the cosmetic catalog
            let catalog = try await service.fetchCosmeticCatalog()

            // Step 2: Retrieve crafting recipes
            let recipes = try await service.fetchCosmeticRecipes()

            // Step 3: Retrieve cosmetics owned by the player
            let owned = try await service.fetchOwnedCosmetics()

            // Step 4: Retrieve current material balances
            let materials = try await service.fetchMaterialsInventory()

            try Task.checkCancellation()

            // Step 5: Update the ViewModel
            cosmeticCatalog = catalog
            cosmeticRecipes = recipes
            ownedCosmetics = owned
            materialsInventory = materials

            // Keep Dashboard fragments synchronized
            craftingFragments = materials.first {
                $0.code == "crafting_fragments"
            }?.quantity ?? 0

            cosmeticError = nil
            
            // Refresh equipped cosmetics
            await refreshEquippedCosmetics()

        } catch is CancellationError {

            print("Cosmetic data refresh cancelled.")

        } catch {

            cosmeticError = "Could not load cosmetic crafting data."

            print(
                "Cosmetic data error: \(error.localizedDescription)"
            )
        }
    }

    
    // MARK: - Cosmetic Ownership

    func ownsCosmetic(_ cosmeticID: UUID) -> Bool {

        ownedCosmetics.contains {
            $0.cosmetic_id == cosmeticID
        }
    }


    // MARK: - Cosmetic Recipe Ingredients

    func ingredients(
        for cosmeticID: UUID
    ) -> [CosmeticRecipeIngredient] {

        cosmeticRecipes.filter {
            $0.cosmetic_id == cosmeticID
        }
    }


    // MARK: - Check Crafting Materials

    func canCraftCosmetic(_ cosmeticID: UUID) -> Bool {

        // The item must exist in the active catalog
        guard cosmeticCatalog.contains(where: {
            $0.id == cosmeticID && $0.is_active
        }) else {
            return false
        }

        // Cannot craft an item already owned
        guard !ownsCosmetic(cosmeticID) else {
            return false
        }

        // Cannot craft while data is loading or a craft is in progress
        guard !isLoadingCosmetics, !isCraftingCosmetic else {
            return false
        }

        let recipe = ingredients(for: cosmeticID)

        guard !recipe.isEmpty else {
            return false
        }

        // Check every ingredient against the player's inventory
        return recipe.allSatisfy { ingredient in

            let available = materialsInventory.first {
                $0.id == ingredient.resource_id
            }?.quantity ?? 0

            return available >= ingredient.quantity
        }
    }

    
    // MARK: - Craft Cosmetic

    @discardableResult
    func craftCosmetic(
        cosmeticID: UUID
    ) async -> Bool {

        // Make sure the player is signed in
        guard supabase.auth.currentUser != nil else {

            cosmeticError = "Sign in to craft cosmetics."
            return false
        }

        // Prevent overlapping crafting requests
        guard !isCraftingCosmetic, !isLoadingCosmetics else {
            return false
        }

        // Find the selected cosmetic
        guard let cosmetic = cosmeticCatalog.first(
            where: { $0.id == cosmeticID }
        ) else {

            cosmeticError = "Cosmetic not found."
            return false
        }

        // Check ownership
        guard !ownsCosmetic(cosmeticID) else {

            cosmeticNotice = "You already own this cosmetic."
            return false
        }

        // Check currently loaded material balances
        guard canCraftCosmetic(cosmeticID) else {

            cosmeticError = "Not enough materials to craft this cosmetic."
            return false
        }

        isCraftingCosmetic = true

        cosmeticError = nil
        cosmeticNotice = nil

        defer {
            isCraftingCosmetic = false
        }

        do {

            // Ask Supabase to craft the cosmetic
            let result = try await service.craftCosmetic(
                cosmeticID: cosmeticID
            )

            // Update balances using values returned by Supabase
            if result.crafted_now {

                materialsInventory = materialsInventory.map { material in

                    MaterialInventoryItem(
                        id: material.id,
                        code: material.code,
                        name: material.name,
                        rarity: material.rarity,
                        quantity:
                            result.remaining_materials[material.code]
                            ?? material.quantity
                    )
                }

                if let fragments =
                    result.remaining_materials["crafting_fragments"] {

                    craftingFragments = fragments
                }
            }

            // Reload ownership, recipes, and material balances
            await refreshCosmeticData()

            // Display the result
            if result.crafted_now {

                cosmeticNotice =
                    "Successfully crafted \(cosmetic.name)!"

            } else {

                cosmeticNotice =
                    "You already own \(cosmetic.name)."
            }

            return result.crafted_now

        } catch {

            cosmeticError = "Could not craft \(cosmetic.name)."

            print(
                "Cosmetic crafting error: \(error.localizedDescription)"
            )

            return false
        }
    }

    
    // MARK: - Refresh Equipped Cosmetics

    func refreshEquippedCosmetics() async {

        guard supabase.auth.currentUser != nil else {

            equippedCosmetics = []
            cosmeticEquipmentError = nil

            return
        }

        do {

            // Retrieve the player's equipped items from Supabase
            let equipped = try await service.fetchEquippedCosmetics()

            try Task.checkCancellation()

            // Update the equipment stored in our ViewModel
            equippedCosmetics = equipped

            cosmeticEquipmentError = nil

        } catch is CancellationError {

            print("Equipment refresh cancelled.")

        } catch {

            cosmeticEquipmentError =
                "Could not load equipped cosmetics."

            print(
                "Equipment refresh error: \(error.localizedDescription)"
            )
        }
    }

    
    // MARK: - Get Equipped Cosmetic

    func equippedCosmeticID(
        for slot: String
    ) -> UUID? {

        equippedCosmetics.first {
            $0.slot == slot
        }?.cosmetic_id
    }


    // MARK: - Check if Cosmetic is Equipped

    func isCosmeticEquipped(
        _ cosmeticID: UUID
    ) -> Bool {

        equippedCosmetics.contains {
            $0.cosmetic_id == cosmeticID
        }
    }

    
    // MARK: - Equip Cosmetic

    @discardableResult
    func equipCosmetic(
        _ cosmetic: CosmeticDefinition
    ) async -> Bool {

        guard supabase.auth.currentUser != nil else {

            cosmeticEquipmentError = "Sign in to equip cosmetics."
            return false
        }

        // Prevent multiple equipment changes at once
        guard !isChangingEquipment else {
            return false
        }

        // Make sure the player owns the cosmetic
        guard ownsCosmetic(cosmetic.id) else {

            cosmeticEquipmentError =
                "You must own this cosmetic before equipping it."

            return false
        }

        isChangingEquipment = true

        cosmeticEquipmentError = nil
        cosmeticEquipmentNotice = nil

        defer {
            isChangingEquipment = false
        }

        do {

            // Ask Supabase to equip the cosmetic
            let result = try await service.equipCosmetic(
                cosmeticID: cosmetic.id,
                slot: cosmetic.cosmetic_type
            )

            // Verify the response
            guard result.slot == cosmetic.cosmetic_type,
                  result.cosmetic_id == cosmetic.id,
                  let equippedAt = result.equipped_at else {

                throw GamificationServiceError.emptyResponse
            }

            // Remove the previously equipped item in this slot
            equippedCosmetics.removeAll {
                $0.slot == result.slot
            }

            // Store the newly equipped cosmetic
            equippedCosmetics.append(
                EquippedCosmetic(
                    slot: result.slot,
                    cosmetic_id: cosmetic.id,
                    equipped_at: equippedAt
                )
            )

            cosmeticEquipmentNotice =
                "\(cosmetic.name) equipped successfully!"

            return true

        } catch {

            cosmeticEquipmentError =
                "Could not equip \(cosmetic.name)."

            print(
                "Equip cosmetic error: \(error.localizedDescription)"
            )

            return false
        }
    }

    
    // MARK: - Unequip Cosmetic

    @discardableResult
    func unequipCosmetic(
        slot: String
    ) async -> Bool {

        guard supabase.auth.currentUser != nil else {

            cosmeticEquipmentError = "Sign in to unequip cosmetics."
            return false
        }

        guard !isChangingEquipment else {
            return false
        }

        isChangingEquipment = true

        cosmeticEquipmentError = nil
        cosmeticEquipmentNotice = nil

        defer {
            isChangingEquipment = false
        }

        do {

            // Ask Supabase to clear the equipment slot
            let result = try await service.unequipCosmetic(
                slot: slot
            )

            // Confirm the slot was cleared
            guard result.slot == slot,
                  result.cosmetic_id == nil else {

                throw GamificationServiceError.emptyResponse
            }

            // Remove the unequipped item from the ViewModel
            equippedCosmetics.removeAll {
                $0.slot == slot
            }

            cosmeticEquipmentNotice =
                "Cosmetic unequipped successfully!"

            return true

        } catch {

            cosmeticEquipmentError =
                "Could not unequip cosmetic."

            print(
                "Unequip cosmetic error: \(error.localizedDescription)"
            )

            return false
        }
    }

}
