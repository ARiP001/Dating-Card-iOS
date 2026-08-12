import Foundation
import Combine
import SwiftData

@MainActor
final class GameplayViewModel: ObservableObject {
    enum State {
        case loading
        case playing
        case packFinished
        case sessionFinished
        case loadFailed
    }

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

    #if DEBUG
    init(
        previewSession: SessionModel,
        topicID: Int,
        previewState: State
    ) {
        self.session = previewSession
        self.topicID = topicID
        self.state = previewState
    }
    #endif

    var topicName: String {
        Topics.all.first(where: { $0.id == topicID })?.name ?? "Topik"
    }

    var currentTopicName: String {
        guard let currentCard else { return topicName }
        return Topics.name(for: currentCard.topicID)
    }

    var currentCard: CardModel? {
        cards.indices.contains(currentIndex)
            ? cards[currentIndex]
            : nil
    }

    func prepare(in context: ModelContext) {
        guard state == .loading else { return }

        do {
            let descriptor = FetchDescriptor<CardModel>(
                predicate: #Predicate { $0.topicID == topicID },
                sortBy: [SortDescriptor(\CardModel.question)]
            )

            let fetchedCards = try context.fetch(descriptor)

            var sessionCards = Array(fetchedCards.prefix(5))

            if let iceBreakingCard = IceBreakings.card(
                for: session.id,
                topicID: topicID
            ) {
                sessionCards.append(iceBreakingCard)
            }

            cards = sessionCards

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

    func recordSwipe(
        _ direction: SwipeDirection,
        in context: ModelContext
    ) {
        guard
            state == .playing,
            !isResolvingSwipe,
            let card = currentCard
        else {
            return
        }

        isResolvingSwipe = true

        let isIceBreakingCard = card.topicID == Topics.iceBreaking.id

        if direction == .right && !isIceBreakingCard {
            card.isPicked = true

            if !session.pickedCards.contains(
                where: { $0.id == card.id }
            ) {
                session.pickedCards.append(card)
            }
        }

        if currentIndex == cards.count - 1 {
            session.currentTopicIDs.removeAll {
                $0 == topicID
            }

            session.lastIndex = max(cards.count - 1, 0)
            session.isContinue = !session.currentTopicIDs.isEmpty

            state = session.currentTopicIDs.isEmpty
                ? .sessionFinished
                : .packFinished

        } else {
            currentIndex += 1
            session.lastIndex = currentIndex
        }

        // Memperbarui waktu agar query di HistoryView otomatis menarik sesi ini ke posisi paling atas
        session.createdAt = Date()

        do {
            try context.save()
        } catch {
            print(
                "Failed to save gameplay progress: \(error)"
            )
        }

        isResolvingSwipe = false
    }

    func keepSessionAvailable(in context: ModelContext) {
        guard !session.currentTopicIDs.isEmpty else {
            return
        }

        session.isContinue = true
        // Pastikan posisi tetap di atas jika pengguna keluar di pertengahan sesi
        session.createdAt = Date()
        try? context.save()
    }
}
