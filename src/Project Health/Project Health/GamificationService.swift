//
//  GamificationService.swift
//  Project Health
//
//  Calls the secure Supabase reward functions.
//  XP and materials are calculated and granted by Supabase,
//  never by this Swift file.
//

import Foundation
import Supabase

struct GamificationActivationResponse: Decodable {
    let awarded: Bool
    let total_xp: Int64
    let crafting_fragments: Int64
    let reward_time_zone: String
}

struct DailyLoginRewardResponse: Decodable {
    let awarded: Bool
    let reward_date: String
    let total_xp: Int64
    let crafting_fragments: Int64
}


nonisolated struct StepGoalRewardResponse: Decodable {
    let awarded: Bool
    let reward_date: String
    let current_steps: Int
    let target_steps: Int?
    let total_xp: Int64
    let crafting_fragments: Int64
}

nonisolated struct WeightCheckinRewardResponse: Decodable {
    let awarded: Bool
    let week_start: String
    let total_xp: Int64
    let crafting_fragments: Int64
}

nonisolated struct WeeklyChallengeProgressResponse: Decodable {
    let week_start: String
    let qualifying_days: Int
    let required_days: Int
    let food_days: Int
    let step_days: Int
    let qualifying_route: String?
    let completed: Bool
    let claimed: Bool
    let total_xp: Int64
    let unopened_rare_packs: Int64
}

nonisolated struct WeeklyChallengeClaimResponse: Decodable {
    let awarded: Bool
    let week_start: String
    let qualifying_days: Int
    let required_days: Int
    let food_days: Int
    let step_days: Int
    let qualifying_route: String?
    let completed: Bool
    let claimed: Bool
    let total_xp: Int64
    let unopened_rare_packs: Int64
}

nonisolated struct RareCrystalPackOpenResponse: Decodable {
    let opened_now: Bool
    let pack_id: UUID
    let crystal_type: String
    let crystals_awarded: Int
    let bonus_awarded: Bool
    let crystal_balance: Int64
    let unopened_rare_packs: Int64
}

nonisolated struct RarePackDefinitionInfo: Decodable {
    let code: String
}

nonisolated struct UnopenedRarePack: Decodable, Identifiable {
    let id: UUID
    let awarded_at: String
    let reward_pack_definitions: RarePackDefinitionInfo
}


// MARK: - Materials Inventory Models

nonisolated struct MaterialDefinition: Decodable {
    let id: UUID
    let code: String
    let name: String
    let rarity: String
}

nonisolated struct MaterialBalance: Decodable {
    let resource_id: UUID
    let quantity: Int64
}

nonisolated struct MaterialInventoryItem: Identifiable {
    let id: UUID
    let code: String
    let name: String
    let rarity: String
    let quantity: Int64
}


// MARK: - Achievement Models

nonisolated struct AchievementProgressResponse: Decodable, Identifiable {

    let achievement_id: UUID

    var id: UUID {
        achievement_id
    }

    let code: String
    let title: String
    let description: String
    let activity_type: String
    let tier: String

    let current_count: Int
    let target_count: Int

    let reward_xp: Int64
    let reward_fragments: Int64

    let icon_name: String
    let unlocked: Bool
    let unlocked_at: String?
}


nonisolated struct AchievementClaimResponse: Decodable {

    let newly_unlocked: Int
    let unlocked_codes: [String]

    let xp_awarded: Int64
    let fragments_awarded: Int64

    let total_xp: Int64
    let crafting_fragments: Int64
}


// MARK: - Featured Achievement Model

nonisolated struct FeaturedAchievementSelection: Decodable, Identifiable {

    let achievement_id: UUID
    let display_order: Int

    var id: UUID {
        achievement_id
    }
}

// MARK: - Cosmetic Crafting Models

nonisolated struct CosmeticDefinition: Decodable, Identifiable {

    let id: UUID
    let code: String
    let name: String
    let description: String

    let collection: String
    let cosmetic_type: String

    let asset_key: String
    let icon_name: String

    let is_active: Bool
    let sort_order: Int
}


// MARK: - Cosmetic Recipe Models

nonisolated struct CosmeticRecipeResource: Decodable {

    let code: String
    let name: String
}

nonisolated struct CosmeticRecipeIngredient: Decodable {

    let cosmetic_id: UUID
    let resource_id: UUID
    let quantity: Int64

    let resource_definitions: CosmeticRecipeResource
}


// MARK: - Owned Cosmetic Model

nonisolated struct OwnedCosmetic: Decodable, Identifiable {

    let cosmetic_id: UUID
    let acquired_at: String

    var id: UUID {
        cosmetic_id
    }
}


// MARK: - Crafting Response Model

nonisolated struct CosmeticCraftResponse: Decodable {

    let crafted_now: Bool

    let cosmetic_id: UUID
    let cosmetic_code: String

    let materials_spent: [String: Int64]
    let remaining_materials: [String: Int64]
}


// MARK: - Equipped Cosmetic Model

nonisolated struct EquippedCosmetic: Decodable, Identifiable {

    let slot: String
    let cosmetic_id: UUID
    let equipped_at: String

    var id: String {
        slot
    }
}


// MARK: - Equipment Response Model

nonisolated struct CosmeticEquipmentResponse: Decodable {

    let slot: String
    let cosmetic_id: UUID?
    let equipped_at: String?
}



enum GamificationServiceError: LocalizedError {
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Supabase did not return a gamification reward result."
        }
    }
}

struct GamificationService {

    // Create a profile (if needed), then claim the starter reward once.
    // Supabase fixes the player's reward time zone on first activation.
    func activateGamification() async throws -> GamificationActivationResponse {
        let results: [GamificationActivationResponse] = try await supabase
            .rpc(
                "activate_gamification",
                params: ["p_time_zone": TimeZone.current.identifier]
            )
            .execute()
            .value

        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }
        return response
    }

    // Claim today's +5 XP and +2 fragments, if not already claimed.
    // Supabase determines the eligible date and prevents duplicate claims.
    func claimDailyLogin() async throws -> DailyLoginRewardResponse {
        let results: [DailyLoginRewardResponse] = try await supabase
            .rpc("claim_daily_login")
            .execute()
            .value

        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }
        return response
    }
    
    
    func claimStepGoal() async throws -> StepGoalRewardResponse {

        // Ask Supabase to check today's step goal
        let results: [StepGoalRewardResponse] = try await supabase
            .rpc("claim_step_goal")
            .execute()
            .value

        // Make sure Supabase returned a result
        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response
    }

    // MARK: - Weekly Weight Check-in Reward

    func claimWeightCheckin(
        weightLogID: UUID
    ) async throws -> WeightCheckinRewardResponse {

        let results: [WeightCheckinRewardResponse] = try await supabase
            .rpc(
                "claim_weight_checkin",
                params: [
                    "p_weight_log_id": weightLogID.uuidString
                ]
            )
            .execute()
            .value

        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response

    }
    
    // MARK: - Weekly Challenge Progress

    func fetchWeeklyChallengeProgress()
    async throws -> WeeklyChallengeProgressResponse {

        let results: [WeeklyChallengeProgressResponse] =
            try await supabase
                .rpc("get_weekly_challenge_progress")
                .execute()
                .value

        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response

    }
    
    // MARK: - Claim Weekly Challenge

    func claimWeeklyChallenge()
    async throws -> WeeklyChallengeClaimResponse {

        let results: [WeeklyChallengeClaimResponse] =
            try await supabase
                .rpc("claim_weekly_challenge")
                .execute()
                .value

        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response

    }
    
    
    // MARK: - Open Rare Crystal Pack

    func openRareCrystalPack(
        packID: UUID,
        crystalType: String
    ) async throws -> RareCrystalPackOpenResponse {

        let results: [RareCrystalPackOpenResponse] =
            try await supabase
                .rpc(
                    "open_rare_crystal_pack",
                    params: [
                        "p_pack_id": packID.uuidString,
                        "p_crystal_type": crystalType
                    ]
                )
                .execute()
                .value

        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response
    }

    
    // MARK: - Fetch Unopened Rare Packs

    func fetchUnopenedRarePacks() async throws -> [UnopenedRarePack] {

        // Make sure a user is signed in
        guard let userID = supabase.auth.currentUser?.id else {
            return []
        }

        // Retrieve this player's unopened rare packs
        let packs: [UnopenedRarePack] = try await supabase
            .from("user_reward_packs")
            .select("""
                id,
                awarded_at,
                reward_pack_definitions!inner(code)
                """)
            .eq("user_id", value: userID.uuidString)
            .eq("reward_pack_definitions.code", value: "rare_crystal_pack")
            .is("opened_at", value: nil)
            .order("awarded_at", ascending: false)
            .execute()
            .value

        return packs
    }
    
    
    // MARK: - Fetch Materials Inventory

    func fetchMaterialsInventory() async throws -> [MaterialInventoryItem] {

        guard let userID = supabase.auth.currentUser?.id else {
            return []
        }

        // Step 1: Get all available material types

        let definitions: [MaterialDefinition] = try await supabase
            .from("resource_definitions")
            .select("id, code, name, rarity")
            .order("name", ascending: true)
            .execute()
            .value

        // Step 2: Get the player's material balances

        let balances: [MaterialBalance] = try await supabase
            .from("user_resources")
            .select("resource_id, quantity")
            .eq("user_id", value: userID.uuidString)
            .execute()
            .value

        // Step 3: Match balances to materials

        let balanceLookup = Dictionary(
            uniqueKeysWithValues: balances.map {
                ($0.resource_id, $0.quantity)
            }
        )

        // Step 4: Build the inventory

        return definitions.map { material in

            MaterialInventoryItem(
                id: material.id,
                code: material.code,
                name: material.name,
                rarity: material.rarity,
                quantity: balanceLookup[material.id] ?? 0
            )
        }
    }

    
    // MARK: - Fetch Achievement Progress

    func fetchAchievementProgress()
    async throws -> [AchievementProgressResponse] {

        let achievements: [AchievementProgressResponse] =
            try await supabase
                .rpc("get_achievement_progress")
                .execute()
                .value

        return achievements
    }


    // MARK: - Claim Achievements

    func claimAchievements()
    async throws -> AchievementClaimResponse {

        let results: [AchievementClaimResponse] =
            try await supabase
                .rpc("claim_achievements")
                .execute()
                .value

        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response
    }

    
    // MARK: - Fetch Featured Achievements

    func fetchFeaturedAchievements() async throws -> [FeaturedAchievementSelection] {

        guard let userID = supabase.auth.currentUser?.id else {
            return []
        }

        // Retrieve the player's selected achievements
        let featured: [FeaturedAchievementSelection] = try await supabase
            .from("user_featured_achievements")
            .select("achievement_id, display_order")
            .eq("user_id", value: userID.uuidString)
            .order("display_order", ascending: true)
            .execute()
            .value

        return featured
    }

    
    // MARK: - Save Featured Achievements

    func saveFeaturedAchievements(
        _ achievementIDs: [UUID]
    ) async throws -> [FeaturedAchievementSelection] {

        // Convert UUIDs into values Supabase can receive
        let selectedIDs = achievementIDs.map {
            $0.uuidString
        }

        // Ask Supabase to save the selected badges
        let featured: [FeaturedAchievementSelection] =
            try await supabase
                .rpc(
                    "set_featured_achievements",
                    params: [
                        "p_achievement_ids": selectedIDs
                    ]
                )
                .execute()
                .value

        return featured
    }
    
    // MARK: - Fetch Cosmetic Catalog

    func fetchCosmeticCatalog() async throws -> [CosmeticDefinition] {

        guard supabase.auth.currentUser != nil else {
            return []
        }

        // Retrieve all available cosmetics
        let cosmetics: [CosmeticDefinition] = try await supabase
            .from("cosmetic_definitions")
            .select("""
                id,
                code,
                name,
                description,
                collection,
                cosmetic_type,
                asset_key,
                icon_name,
                is_active,
                sort_order
                """)
            .eq("is_active", value: true)
            .order("sort_order", ascending: true)
            .execute()
            .value

        return cosmetics
    }

    
    // MARK: - Fetch Cosmetic Recipes

    func fetchCosmeticRecipes() async throws -> [CosmeticRecipeIngredient] {

        guard supabase.auth.currentUser != nil else {
            return []
        }

        // Retrieve recipes and their material names
        let recipes: [CosmeticRecipeIngredient] = try await supabase
            .from("cosmetic_recipes")
            .select("""
                cosmetic_id,
                resource_id,
                quantity,
                resource_definitions (
                    code,
                    name
                )
                """)
            .execute()
            .value

        return recipes
    }

    // MARK: - Fetch Owned Cosmetics

    func fetchOwnedCosmetics() async throws -> [OwnedCosmetic] {

        guard let userID = supabase.auth.currentUser?.id else {
            return []
        }

        // Retrieve cosmetics this player owns
        let owned: [OwnedCosmetic] = try await supabase
            .from("user_cosmetics")
            .select("cosmetic_id, acquired_at")
            .eq("user_id", value: userID.uuidString)
            .order("acquired_at", ascending: false)
            .execute()
            .value

        return owned
    }

    // MARK: - Craft Cosmetic

    func craftCosmetic(
        cosmeticID: UUID
    ) async throws -> CosmeticCraftResponse {

        // Ask Supabase to perform the crafting operation
        let results: [CosmeticCraftResponse] =
            try await supabase
                .rpc(
                    "craft_cosmetic",
                    params: [
                        "p_cosmetic_id": cosmeticID.uuidString
                    ]
                )
                .execute()
                .value

        // Make sure Supabase returned a result
        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response
    }

    
    // MARK: - Fetch Equipped Cosmetics

    func fetchEquippedCosmetics() async throws -> [EquippedCosmetic] {

        guard let userID = supabase.auth.currentUser?.id else {
            return []
        }

        // Retrieve the player's equipped cosmetics
        let equipped: [EquippedCosmetic] = try await supabase
            .from("user_equipped_cosmetics")
            .select("slot, cosmetic_id, equipped_at")
            .eq("user_id", value: userID.uuidString)
            .order("slot", ascending: true)
            .execute()
            .value

        return equipped
    }

    
    // MARK: - Equip Cosmetic

    func equipCosmetic(
        cosmeticID: UUID,
        slot: String
    ) async throws -> CosmeticEquipmentResponse {

        // Ask Supabase to equip the selected cosmetic
        let results: [CosmeticEquipmentResponse] =
            try await supabase
                .rpc(
                    "set_equipped_cosmetic",
                    params: [
                        "p_slot": slot,
                        "p_cosmetic_id": cosmeticID.uuidString
                    ]
                )
                .execute()
                .value

        // Make sure Supabase returned a result
        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response
    }

    
    // MARK: - Unequip Cosmetic

    func unequipCosmetic(
        slot: String
    ) async throws -> CosmeticEquipmentResponse {

        // Ask Supabase to clear this equipment slot
        let results: [CosmeticEquipmentResponse] =
            try await supabase
                .rpc(
                    "set_equipped_cosmetic",
                    params: [
                        "p_slot": slot
                    ]
                )
                .execute()
                .value

        // Make sure Supabase returned a result
        guard let response = results.first else {
            throw GamificationServiceError.emptyResponse
        }

        return response
    }

}
