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
        /// Topik dipilih, tapi kartu pertanyaan yang belum pernah dimainkan
        /// (`isPicked == false`) untuk topik itu sudah habis. Membawa nama
        /// topik untuk ditampilkan di wording empty state.
        case topicExhausted(String)
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
                enterGameplayIfAvailable(topicID: topicID, in: modelContext)
            } else {
                prepareNextPack(in: modelContext)
            }
            return
        }

        do {
            // Kasus 1: memang tidak ada topik yang cocok sama sekali dari
            // preferensi (union - hated topics kosong).
            guard !topicIDs.isEmpty else {
                screenState = .empty
                return
            }

            // Kasus 2: topik cocok ada, tapi semua kartunya sudah pernah
            // dimainkan (isPicked == true di semua topik). Dicek DULU
            // sebelum bikin SessionModel, supaya sesi kosong tidak nyangkut
            // di history — kalau memang habis, wording-nya juga beda dari
            // "belum ada topik yang cocok" (pakai .topicExhausted).
            let allCards = try modelContext.fetch(FetchDescriptor<CardModel>())
            let hasAnyAvailableCard = allCards.contains {
                topicIDs.contains($0.topicID) && !$0.isPicked
            }

            guard hasAnyAvailableCard else {
                if topicIDs.count == 1, let onlyTopicID = topicIDs.first {
                    let name = Topics.all.first { $0.id == onlyTopicID }?.name ?? "topik ini"
                    screenState = .topicExhausted(name)
                } else {
                    // Lebih dari 1 topik gabungan tapi semuanya habis —
                    // tetap dianggap "tidak ada topik yang cocok" untuk
                    // dimainkan, karena tidak ada satupun kartu tersisa.
                    screenState = .empty
                }
                return
            }

            // Baru insert sesi setelah dipastikan ada kartu yang bisa
            // dimainkan, supaya sesi yang benar-benar kosong tidak pernah
            // tersimpan ke history.
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
            // Sesi (beserta selectedTopicIDs & currentTopicIDs) langsung
            // di-insert & disimpan di sini, sebelum CardShufflingView
            // (state .shuffling) sempat ditampilkan/berinteraksi.
            try modelContext.save()

            let pickedCount = try buildPickedPack(
                topicIDs: topicIDs,
                session: newSession,
                modelContext: modelContext
            )

            // Karena hasAnyAvailableCard sudah dipastikan true di atas,
            // pickedCount seharusnya tidak pernah 0 di titik ini. Ini
            // cuma pengaman terakhir kalau ada race condition data.
            if pickedCount == 0 {
                screenState = .empty
            }
        } catch {
            screenState = .empty
            print(
                "Failed to prepare Would You Rather session: \(error)"
            )
        }
    }

    func proceedFromShuffling(in modelContext: ModelContext) {
        if let onlyCard = pickedPackCards.first, pickedPackCards.count == 1 {
            session?.lastTopicID = onlyCard.topicID
            session?.lastIndex = 0
            enterGameplayIfAvailable(topicID: onlyCard.topicID, in: modelContext)
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

    func startSelectedTopic(in modelContext: ModelContext) {
        guard let selectedCardID,
              let selected = pickedPackCards.first(where: { $0.id == selectedCardID }) else { return }
        session?.lastTopicID = selected.topicID
        session?.lastIndex = 0
        enterGameplayIfAvailable(topicID: selected.topicID, in: modelContext)
    }

    func prepareNextPack(in modelContext: ModelContext) {
        guard let session else { return }
        let remainingIDs = session.currentTopicIDs
        guard !remainingIDs.isEmpty else { screenState = .empty; return }

        do {
            let pickedCount = try buildPickedPack(
                topicIDs: remainingIDs,
                session: session,
                modelContext: modelContext
            )

            switch pickedCount {
            case 0:
                screenState = .empty
            case 1:
                guard let onlyCard = pickedPackCards.first else {
                    screenState = .empty
                    return
                }
                enterGameplayIfAvailable(topicID: onlyCard.topicID, in: modelContext)
            default:
                screenState = .picking
            }
        } catch {
            screenState = .empty
        }
    }

    // MARK: - Gameplay Entry

    /// Dipanggil sebelum masuk `.gameplay(topicID)`. Mengecek dulu apakah
    /// kartu yang belum dimainkan (`isPicked == false`) untuk topik itu
    /// masih tersedia (1-5 kartu). Kalau sudah habis (0 kartu tersisa),
    /// tampilkan `.topicExhausted` alih-alih masuk ke gameplay.
    func enterGameplayIfAvailable(topicID: Int, in modelContext: ModelContext) {
        let remainingCount = remainingCardCount(for: topicID, in: modelContext)

        if remainingCount > 0 {
            screenState = .gameplay(topicID)
        } else {
            let name = Topics.all.first { $0.id == topicID }?.name ?? "topik ini"
            screenState = .topicExhausted(name)
        }
    }

    private func remainingCardCount(for topicID: Int, in modelContext: ModelContext) -> Int {
        let descriptor = FetchDescriptor<CardModel>(
            predicate: #Predicate { $0.topicID == topicID && !$0.isPicked }
        )
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }

    // MARK: - Pack Building

    @discardableResult
    private func buildPickedPack(
        topicIDs: [Int],
        session: SessionModel,
        modelContext: ModelContext
    ) throws -> Int {
        let allCards = try modelContext.fetch(FetchDescriptor<CardModel>())
            .filter { !$0.isPicked }

        // MARK: - 1. Tentukan pickedPackCards (2 Kartu Kandidat)
        if topicIDs.count == 1, let onlyTopicID = topicIDs.first {
            let topicCards = allCards
                .filter { $0.topicID == onlyTopicID }
                .shuffled()
            
            if topicCards.count >= 2 {
                // Ambil 2 kartu berbeda dari topik yang sama
                pickedPackCards = Array(topicCards.prefix(2))
            } else if let onlyCard = topicCards.first {
                // Jika sisa 1 kartu saja, duplikasi kartu tersebut agar UI tetap punya 2 pasang
                pickedPackCards = [onlyCard, onlyCard]
            } else {
                pickedPackCards = []
            }
        } else {
            // Lebih dari 1 topik
            let oneCardPerTopic = topicIDs.compactMap { topicID in
                allCards.filter { $0.topicID == topicID }.randomElement()
            }
            pickedPackCards = Array(oneCardPerTopic.shuffled().prefix(2))
        }

        // MARK: - 2. Tentukan currentPackCards (Untuk Spinning Carousel)
        if topicIDs.count == 1 {
            // Jika sisa 1 topik, pastikan carousel HANYA diisi oleh 2 kartu terpilih dari topik yang sama
            currentPackCards = pickedPackCards
        } else {
            // Jika topik > 1, susun carousel dari selectedTopicIDs dengan menyertakan pickedPackCards
            let selectedTopicIDs = session.selectedTopicIDs
            var newCurrentPackCards: [CardModel] = []
            var representedTopics = Set<Int>()

            // Masukkan pickedPackCards terlebih dahulu agar ID-nya terjamin ada di carousel
            for card in pickedPackCards {
                newCurrentPackCards.append(card)
                representedTopics.insert(card.topicID)
            }

            // Isi sisanya dari topik lain untuk variasi carousel
            for topicID in selectedTopicIDs {
                if !representedTopics.contains(topicID) {
                    let filler = allCards.filter { $0.topicID == topicID }.randomElement()
                        ?? CardModel(topicID: topicID, question: "")
                    newCurrentPackCards.append(filler)
                }
            }
            currentPackCards = newCurrentPackCards.shuffled()
        }

        animationTopicIDs = Topics.all.map(\.id).shuffled()
        selectedCardID = nil

        if pickedPackCards.count == 1, let onlyCard = pickedPackCards.first {
            session.lastTopicID = onlyCard.topicID
            session.lastIndex = 0
        }

        try modelContext.save()
        return pickedPackCards.count
    }
}
