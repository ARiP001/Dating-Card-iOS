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
        case gameplay(Int)
        case empty
    }

    @Published private(set) var screenState: ScreenState = .shuffling
    @Published private(set) var currentPackCards: [CardModel] = []
    @Published private(set) var pickedPackCards: [CardModel] = []
    @Published private(set) var animationTopicIDs: [Int]
    @Published private(set) var session: SessionModel?
    @Published var selectedCardID: UUID?

    private let topicIDs: [Int]
    private let existingSession: SessionModel?
    private var hasPreparedSession = false

    init(topicIDs: [Int]) {
        let validTopicIDs = Set(Topics.all.map(\.id))
        let normalizedTopicIDs = Array(
            Set(topicIDs).intersection(validTopicIDs)
        )
        .sorted()

        self.topicIDs = normalizedTopicIDs
        self.animationTopicIDs = normalizedTopicIDs.shuffled()
        self.existingSession = nil
    }

    init(session: SessionModel) {
        self.topicIDs = session.selectedTopicIDs
        self.animationTopicIDs = session.selectedTopicIDs.shuffled()
        self.existingSession = session
    }

    func prepareSession(in modelContext: ModelContext) {
        guard !hasPreparedSession else { return }
        hasPreparedSession = true

        if let existingSession {
            session = existingSession
            if let topicID = existingSession.lastTopicID,
               existingSession.currentTopicIDs.contains(topicID) {
                screenState = .gameplay(topicID)
            } else {
                prepareNextPack(in: modelContext)
            }
            return
        }

        do {
            guard !topicIDs.isEmpty else {
                screenState = .empty
                return
            }

            // Create a session using the topics selected by the user.
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "id_ID")
            dateFormatter.dateFormat = "EEEE, dd MMMM yyyy"
            let sessionTitle = dateFormatter.string(from: Date())

            let newSession = SessionModel(
                isContinue: true,
                title: sessionTitle,
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

            let descriptor = FetchDescriptor<CardModel>()

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

            if pickedPackCards.count == 1, let card = pickedPackCards.first {
                newSession.lastTopicID = card.topicID
                newSession.lastIndex = 0
                try modelContext.save()
            } else if pickedPackCards.count < 2 {
                screenState = .empty
            }

        } catch {
            screenState = .empty
            print(
                "Failed to prepare Would You Rather session: \(error)"
            )
        }
    }

    func proceedFromShuffling() {
        if let onlyCard = pickedPackCards.first, pickedPackCards.count == 1 {
            session?.lastTopicID = onlyCard.topicID
            session?.lastIndex = 0
            screenState = .gameplay(onlyCard.topicID)
        } else {
            screenState = .picking
        }
    }

    func finishPickingAnimation() {
        screenState = .choosing
    }

    func select(_ card: CardModel) {
        selectedCardID = card.id
    }

    func startSelectedTopic() {
        guard let selectedCardID,
              let selected = pickedPackCards.first(where: { $0.id == selectedCardID }) else { return }
        session?.lastTopicID = selected.topicID
        session?.lastIndex = 0
        screenState = .gameplay(selected.topicID)
    }

    func prepareNextPack(in modelContext: ModelContext) {
        guard let session else { return }
        let remainingIDs = session.currentTopicIDs
        guard !remainingIDs.isEmpty else { screenState = .empty; return }

        do {
            let cards = try modelContext.fetch(FetchDescriptor<CardModel>())
            currentPackCards = remainingIDs.compactMap { topicID in
                cards.filter { $0.topicID == topicID }.randomElement()
            }
            animationTopicIDs = session.selectedTopicIDs.shuffled()
            selectedCardID = nil
            pickedPackCards = Array(currentPackCards.shuffled().prefix(2))

            if pickedPackCards.count == 1, let onlyCard = pickedPackCards.first {
                session.lastTopicID = onlyCard.topicID
                session.lastIndex = 0
                try modelContext.save()
                screenState = .gameplay(onlyCard.topicID)
            } else if pickedPackCards.count == 2 {
                try modelContext.save()
                screenState = .picking
            } else {
                screenState = .empty
            }
        } catch {
            screenState = .empty
        }
    }
}
