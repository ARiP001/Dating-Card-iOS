//
//  WouldYouRatherViewModel.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 11/08/26.
//

import Combine
import Foundation
import SwiftData

@MainActor
final class WouldYouRatherViewModel: ObservableObject {

    enum ScreenState: Equatable {
        case shuffling
        case picking
        case choosing
        case empty
    }

    @Published private(set) var screenState: ScreenState = .shuffling
    @Published private(set) var currentPackCards: [CardModel] = []
    @Published private(set) var pickedPackCards: [CardModel] = []
    @Published private(set) var animationTopicIDs: [Int]
    @Published private(set) var session: SessionModel?
    @Published var selectedCardID: UUID?

    private let topicIDs: [Int]
    private var hasPreparedSession = false

    init(topicIDs: [Int]) {
        self.topicIDs = topicIDs

        // First animation always uses all available topics.
        self.animationTopicIDs = Topics.all.map(\.id).shuffled()
    }

    func prepareSession(in modelContext: ModelContext) {
        guard !hasPreparedSession else { return }
        hasPreparedSession = true

        do {
            guard !topicIDs.isEmpty else {
                screenState = .empty
                return
            }

            // Create a session using the topics selected by the user.
            let newSession = SessionModel(
                isContinue: true,
                selectedTopicIDs: topicIDs,
                currentTopicIDs: topicIDs,
                pickedCards: [],
                lastTopicID: topicIDs.first,
                lastIndex: 0
            )

            modelContext.insert(newSession)

            // Pick one random card from each selected topic.
            let descriptor = FetchDescriptor<CardModel>(
                predicate: #Predicate {
                    !$0.isPicked
                }
            )

            let availableCards = try modelContext.fetch(descriptor)

            currentPackCards = topicIDs.compactMap { topicID in
                availableCards
                    .filter { $0.topicID == topicID }
                    .randomElement()
            }

            // Pick 2 topics/cards for Would You Rather.
            pickedPackCards = Array(
                currentPackCards.shuffled().prefix(2)
            )

            guard currentPackCards.count == topicIDs.count,
                  pickedPackCards.count == 2 else {
                screenState = .empty
                return
            }

            try modelContext.save()

            session = newSession

        } catch {
            screenState = .empty
            print(
                "Failed to prepare Would You Rather session: \(error)"
            )
        }
    }

    func proceedFromShuffling() {
        screenState = .picking
    }

    func finishPickingAnimation() {
        screenState = .choosing
    }

    func select(
        _ card: CardModel,
        in modelContext: ModelContext
    ) {
        selectedCardID = card.id
        card.isPicked = true

        session?.pickedCards.append(card)

        do {
            try modelContext.save()
        } catch {
            print(
                "Failed to save picked card: \(error)"
            )
        }
    }
}
