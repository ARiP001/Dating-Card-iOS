//
//  GameplayViewModel.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 12/08/26.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class GameplayViewModel: ObservableObject {
    enum State { case loading, playing, packFinished, sessionFinished, loadFailed }

    @Published private(set) var state: State = .loading
    @Published private(set) var cards: [CardModel] = []
    @Published private(set) var currentIndex = 0
    let session: SessionModel
    let topicID: Int
    private var isResolvingSwipe = false

    init(session: SessionModel, topicID: Int) {
        self.session = session
        self.topicID = topicID
    }

    var topicName: String { Topics.all.first(where: { $0.id == topicID })?.name ?? "Topik" }
    var currentCard: CardModel? { cards.indices.contains(currentIndex) ? cards[currentIndex] : nil }

    func prepare(in context: ModelContext) {
        guard state == .loading else { return }

        do {
            // Kartu boleh dipakai kembali pada sesi baru. Progress dalam
            // sesi aktif disimpan lewat lastIndex/currentTopicIDs, sedangkan
            // isPicked hanya menandai kartu yang disimpan ke History.
            let descriptor = FetchDescriptor<CardModel>(
                predicate: #Predicate { $0.topicID == topicID },
                sortBy: [SortDescriptor(\CardModel.question)]
            )

            let fetchedCards = try context.fetch(descriptor)

            // Maksimal 5 kartu per sesi pack, tapi tersedia 1-5 kartu pun
            // tetap dianggap valid untuk dimainkan (bukan cuma tepat 5).
            cards = Array(fetchedCards.prefix(5))

            currentIndex = min(
                max(session.lastIndex ?? 0, 0),
                max(cards.count - 1, 0)
            )

            state = cards.isEmpty ? .loadFailed : .playing

        } catch {
            state = .loadFailed
            print("Failed to load gameplay cards:", error)
        }
    }

    func recordSwipe(_ direction: SwipeDirection, in context: ModelContext) {
        guard state == .playing, !isResolvingSwipe, let card = currentCard else { return }
        isResolvingSwipe = true
        if direction == .right {
            card.isPicked = true
            if !session.pickedCards.contains(where: { $0.id == card.id }) { session.pickedCards.append(card) }
        }
        if currentIndex == cards.count - 1 {
            session.currentTopicIDs.removeAll { $0 == topicID }
            session.lastIndex = 4
            session.isContinue = !session.currentTopicIDs.isEmpty
            state = session.currentTopicIDs.isEmpty ? .sessionFinished : .packFinished
        } else {
            currentIndex += 1
            session.lastIndex = currentIndex
        }
        do { try context.save() } catch { print("Failed to save gameplay progress: \(error)") }
        isResolvingSwipe = false
    }

    func keepSessionAvailable(in context: ModelContext) {
        guard !session.currentTopicIDs.isEmpty else { return }
        session.isContinue = true
        try? context.save()
    }
}
