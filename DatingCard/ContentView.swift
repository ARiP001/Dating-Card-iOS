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
                .task {
                    // Older installations may have been seeded before every
                    // topic received its five-card gameplay pack.
                    seedCards()
                }
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

            let existingTopicCounts = Dictionary(grouping: existingCards, by: \ .topicID)
                .mapValues(\.count)

            for topic in Topics.all where (existingTopicCounts[topic.id] ?? 0) < 5 {
                let missingCount = 5 - (existingTopicCounts[topic.id] ?? 0)
                for card in CardData.createAll().filter({ $0.topicID == topic.id }).prefix(missingCount) {
                    modelContext.insert(card)
                }
            }

            try modelContext.save()
            
            // Baru true setelah seeding berhasil
           hasFinishedOnboarding = true
        } catch {
            print("Failed to seed cards: \(error)")
        }
    }
}
