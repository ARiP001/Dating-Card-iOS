//
//  ContentView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var cards: [CardModel]

    @Environment(\.modelContext)
    private var modelContext

    var body: some View {
        NavigationStack {
            List(cards) { card in
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.question)
                        .font(.headline)
                    HStack {
                        Text(
                            Topics.all.first { $0.id == card.topicID }?.name ?? "Unknown Topic"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        Text("(\(card.topicID))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text("Picked: \(card.isPicked ? "Yes" : "No")")
                        .font(.caption)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        card.isPicked = true

                        do {
                            try modelContext.save()
                        } catch {
                            print("Failed to save card: \(error)")
                        }
                    } label: {
                        Label("Picked", systemImage: "checkmark")
                    }
                    .tint(.green)
                }
            }
            .navigationTitle("Cards")
        }
        .task {
            do {
                let descriptor = FetchDescriptor<CardModel>()
                let existingCards = try modelContext.fetch(descriptor)

                guard existingCards.isEmpty else { return }

                for card in CardData.createAll() {
                    modelContext.insert(card)
                }

                try modelContext.save()
            } catch {
                print("Seeding failed: \(error)")
            }
        }
    }
}
