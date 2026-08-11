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
        let validTopicIDs = Set(Topics.all.map(\.id))
        let normalizedTopicIDs = Array(
            Set(topicIDs).intersection(validTopicIDs)
        )
        .sorted()

        self.topicIDs = normalizedTopicIDs
        self.animationTopicIDs = normalizedTopicIDs.shuffled()
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
            session = newSession

            // The shuffle animation reads the topic pool saved in the
            // session, rather than displaying every topic in Topics.all.
            animationTopicIDs = newSession.selectedTopicIDs.shuffled()
            try modelContext.save()

            // Pick one random persisted card from each selected topic. Until
            // the full question data is available, a lightweight topic card
            // keeps the Would You Rather UI usable for every valid topic.
            let descriptor = FetchDescriptor<CardModel>(
                predicate: #Predicate {
                    !$0.isPicked
                }
            )

            let availableCards = try modelContext.fetch(descriptor)

            currentPackCards = topicIDs.map { topicID in
                availableCards
                    .filter { $0.topicID == topicID }
                    .randomElement()
                    ?? CardModel(
                        topicID: topicID,
                        question: ""
                    )
            }

            // Pick 2 topics/cards for Would You Rather.
            pickedPackCards = Array(
                currentPackCards.shuffled().prefix(2)
            )

            guard pickedPackCards.count == 2 else {
                screenState = .empty
                return
            }

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
