//
//  RarePackInventory.swift
//  Project Health
//
//  Created by Joseph Gaza on 11/8/26.
//


import SwiftUI

struct RarePackInventoryView: View {

    @ObservedObject var gamificationViewModel: GamificationViewModel

    // MARK: - View State

    @State private var isLoading = true
    @State private var isOpeningPack = false

    @State private var selectedPackID: UUID?
    @State private var showCrystalSelection = false

    @State private var showResult = false
    @State private var resultMessage = ""

    var body: some View {

        List {

            // MARK: - Unopened Packs

            Section("Unopened Rare Crystal Packs") {

                if isLoading {

                    ProgressView("Loading inventory...")

                } else if gamificationViewModel.unopenedRarePackItems.isEmpty {

                    VStack(spacing: 12) {

                        Image(systemName: "gift")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)

                        Text("No unopened packs")

                        Text("Complete weekly challenges to earn Rare Crystal Packs.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()

                } else {

                    ForEach(gamificationViewModel.unopenedRarePackItems) { pack in

                        HStack(spacing: 12) {

                            Image(systemName: "gift.fill")
                                .font(.title2)
                                .foregroundColor(.purple)

                            VStack(alignment: .leading, spacing: 4) {

                                Text("Rare Crystal Pack")
                                    .font(.headline)

                                Text("Contains 2–3 rare crystals")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Button("Open") {

                                selectedPackID = pack.id
                                showCrystalSelection = true
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(isOpeningPack)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            // MARK: - Pack Information

            Section("How Rare Packs Work") {

                Text("Choose Astral, Nature, or Cyber Crystals when opening a pack.")

                Text("Each pack guarantees 2 crystals, with a 20% chance of receiving 1 bonus crystal.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Rare Pack Inventory")
        .navigationBarTitleDisplayMode(.inline)

        // Load the inventory when this screen opens
        .task {

            isLoading = true

            await gamificationViewModel.refreshUnopenedRarePacks()

            isLoading = false
        }

        // Pull down to refresh
        .refreshable {

            await gamificationViewModel.refreshUnopenedRarePacks()
        }

        // MARK: - Crystal Selection

        .confirmationDialog(
            "Choose Your Crystals",
            isPresented: $showCrystalSelection,
            titleVisibility: .visible
        ) {

            Button("Astral Crystals") {
                openSelectedPack(crystalType: "astral_crystals")
            }

            Button("Nature Crystals") {
                openSelectedPack(crystalType: "nature_crystals")
            }

            Button("Cyber Crystals") {
                openSelectedPack(crystalType: "cyber_crystals")
            }

            Button("Cancel", role: .cancel) {}

        } message: {

            Text("Your selection determines which crystals you receive.")
        }

        // MARK: - Opening Result

        .alert(
            "Rare Crystal Pack",
            isPresented: $showResult
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(resultMessage)
        }
    }

    // MARK: - Open Selected Pack

    private func openSelectedPack(crystalType: String) {

        guard let packID = selectedPackID,
              !isOpeningPack else {
            return
        }

        isOpeningPack = true

        Task {

            defer {
                isOpeningPack = false
            }

            do {

                // Ask Supabase to open the selected pack
                let result = try await GamificationService()
                    .openRareCrystalPack(
                        packID: packID,
                        crystalType: crystalType
                    )

                // Refresh the inventory after opening
                await gamificationViewModel.refreshUnopenedRarePacks()

                if result.opened_now {

                    let bonusText = result.bonus_awarded
                        ? " You received a bonus crystal!"
                        : ""

                    resultMessage =
                        "You received \(result.crystals_awarded) \(result.crystal_type.replacingOccurrences(of: "_", with: " "))!" + bonusText

                } else {

                    resultMessage =
                        "This pack has already been opened."
                }

            } catch {

                resultMessage =
                    "Could not open pack: \(error.localizedDescription)"
            }

            showResult = true
        }
    }

} // Closes RarePackInventoryView
