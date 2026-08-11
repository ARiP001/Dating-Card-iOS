//
//  ContentView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasFinishedOnboarding")
    private var hasFinishedOnboarding = false

    @Environment(\.modelContext)
    private var modelContext

    var body: some View {
        if hasFinishedOnboarding {
            MainTabView()
        } else {
            OnboardingView {
                seedCards()
            }
        }
    }

    private func seedCards() {
        do {
            let descriptor = FetchDescriptor<CardModel>()
            let existingCards = try modelContext.fetch(descriptor)

            // Prevent duplicate seeding
            guard existingCards.isEmpty else {
                hasFinishedOnboarding = true
                return
            }

            for card in CardData.createAll() {
                modelContext.insert(card)
            }

            try modelContext.save()
            
            // Baru true setelah seeding berhasil
           hasFinishedOnboarding = true
        } catch {
            print("Failed to seed cards: \(error)")
        }
    }
}
