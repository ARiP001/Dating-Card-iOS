//
//  WouldYouRatherView.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 11/08/26.
//

import SwiftData
import SwiftUI

struct WouldYouRatherView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: WouldYouRatherViewModel

    init(topicIDs: [Int]) {
        _viewModel = StateObject(
            wrappedValue: WouldYouRatherViewModel(
                topicIDs: topicIDs
            )
        )
    }

    init(session: SessionModel) {
        _viewModel = StateObject(wrappedValue: WouldYouRatherViewModel(session: session))
    }

    var body: some View {
        ZStack {
            switch viewModel.screenState {
            case .shuffling:
                CardShufflingView(
                    topicIDs: viewModel.animationTopicIDs
                ) {
                    withAnimation(
                        .spring(
                            response: 0.5,
                            dampingFraction: 0.8
                        )
                    ) {
                        viewModel.proceedFromShuffling(in: modelContext)
                    }
                }
                .transition(.opacity)
                .zIndex(0)

            case .picking:
                WouldYouRatherPickingView(
                    cards: viewModel.currentPackCards,
                    pickedCards: viewModel.pickedPackCards
                ) {
                    withAnimation(
                        .spring(
                            response: 0.45,
                            dampingFraction: 0.85
                        )
                    ) {
                        viewModel.finishPickingAnimation()
                    }
                }
                .transition(
                    .scale(scale: 0.6)
                    .combined(with: .opacity)
                )
                .zIndex(1)

            case .choosing:
                WouldYouRatherSelectionView(
                    cards: viewModel.pickedPackCards,
                    selectedCardID: $viewModel.selectedCardID,
                    onConfirm: {
                        viewModel.startSelectedTopic(in: modelContext)
                    },
                    onDismiss: {
                        dismiss()
                    }
                )
                .transition(.opacity)
                .zIndex(2)

            case let .gameplay(topicID):
                if let session = viewModel.session {
                    GameplayView(
                        session: session,
                        topicID: topicID,
                        onOpenAnotherPack: {
                            viewModel.prepareNextPack(in: modelContext)
                        }
                    )
                    .transition(.opacity)
                    .zIndex(3)
                }

            case let .topicExhausted(topicName):
                topicExhaustedContent(topicName: topicName)
                    .zIndex(4)

            case .empty:
                emptyContent
                    .zIndex(5)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .animation(
            .easeInOut(duration: 0.35),
            value: viewModel.screenState
        )
        .task {
            viewModel.prepareSession(
                in: modelContext
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var emptyContent: some View {
        AppEmptyState(
            title: "Belum ada topik yang tersedia",
            message: "Gabungan topik yang kalian pilih sudah dikurangi dengan topik yang belum ingin dibagikan. Coba pilih topik lain untuk memulai sesi.",
            actionTitle: "Kembali ke Home"
        ) {
            dismiss()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
    }

    private func topicExhaustedContent(topicName: String) -> some View {
        AppEmptyState(
            title: "Kartu untuk topik ini sudah habis",
            message: "Selamat, kamu sudah memahami \(topicName) dengan baik sejauh ini. Yuk pilih topik lain untuk terus mengenal satu sama lain.",
            actionTitle: "Kembali ke Home"
        ) {
            dismiss()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea())
    }

}

// MARK: - Selection View
private struct WouldYouRatherSelectionView: View {
    let cards: [CardModel]

    @Binding var selectedCardID: UUID?

    let onConfirm: () -> Void
    let onDismiss: () -> Void
    @State private var showsExitConfirmation = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.bgPrimary.ignoresSafeArea()
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                header
                VStack(spacing: 16) {
                    optionCard(at: 0)
                    optionCard(at: 1)
                }
                .padding(.top, 8)

                Spacer()

                confirmButton
            }
            .padding(.horizontal, 32)
            .padding(.top, 64)
            .padding(.bottom, 32)

            // MARK: - Close Button (Header Top Trailing)
            Button {
                showsExitConfirmation = true
            } label: {
                Image(systemName: "xmark")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(Color.textPrimary)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(.top, Spacing.md)
            .padding(.trailing, Spacing.xl)

            if showsExitConfirmation {
                SessionExitConfirmation(
                    title: "Hentikan Pemilihan Topik?",
                    message: "Jika sesi ini diakhiri sekarang, kamu dapat melanjutkannya kembali melalui riwayat permainan.",
                    continueTitle: "Lanjutkan Pemilihan Topik",
                    exitTitle: "Keluar",
                    onContinue: { showsExitConfirmation = false },
                    onExit: onDismiss
                )
                .zIndex(2)
            }
        }
    }

    // MARK: - Header (Body Section)

    private var header: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text("Pilih Topik yang Ingin Dibahas")
                .font(.title2.bold())
                .foregroundStyle(Color.textPrimary)

            Text(
                "Diskusikan topik mana yang ingin kalian bahas bersama."
            )
            .font(AppFont.bodyRegular)
            .foregroundStyle(Color.textPrimary)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
    }

    // MARK: - Confirm Button

    private var confirmButton: some View {
        Button {
            onConfirm()
        } label: {
            Text("Kami Pilih Ini")
                .font(.headline)
                .foregroundStyle(
                    selectedCardID == nil
                    ? Color.accentPrimary
                    : .white
                )
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    selectedCardID == nil
                    ? Color(.systemGray6)
                    : Color.accentPrimary
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 28
                    )
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 28
                    )
                    .stroke(
                        Color.accentPrimary,
                        lineWidth:
                            selectedCardID == nil
                            ? 1.5
                            : 0
                    )
                }
                .shadow(
                    color: .black.opacity(
                        selectedCardID == nil
                        ? 0
                        : 0.16
                    ),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        }
        .buttonStyle(.plain)
        .disabled(
            selectedCardID == nil
        )
    }

    // MARK: - Option Card

    private func optionCard(
        at index: Int
    ) -> some View {
        guard cards.indices.contains(index) else {
            return AnyView(
                TopicOptionCard(
                    title: "",
                    value: UUID(),
                    topicID: nil,
                    width: .infinity,
                    height: 260,
                    selection: .constant(nil)
                )
                .disabled(true)
            )
        }

        let card = cards[index]

        return AnyView(
            TopicOptionCard(
                title: topicName(
                    for: card.topicID
                ),
                value: card.id,
                topicID: card.topicID,
                width: .infinity,
                height: 260,
                selection: $selectedCardID
            )
        )
    }

    // MARK: - Topic Name

    private func topicName(
        for topicID: Int
    ) -> String {
        Topics.all.first {
            $0.id == topicID
        }?.name ?? "Topic \(topicID)"
    }
}

// MARK: - Picking View

private struct WouldYouRatherPickingView: View {
    let cards: [CardModel]
    let pickedCards: [CardModel]
    let onFinished: () -> Void

    @State private var phase: PickingPhase = .spinning
    @State private var startDate = Date()
    @State private var frozenProgress: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(
                        color: .bgPrimary,
                        location: 0.0
                    ),
                    .init(
                        color: .bgPrimary,
                        location: 0.35
                    ),
                    .init(
                        color: .accentPrimary,
                        location: 0.85
                    )
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ConcentricDashedCirclesView()
                .clipped()

            VStack(spacing: 24) {
                Spacer()

                CarouselPickingView(
                    cards: displayCards,
                    phase: phase,
                    pickedCards: pickedChoiceCards,
                    startDate: startDate,
                    frozenProgress: frozenProgress,
                    placement: placement
                )
                .frame(height: 260)
                .frame(maxWidth: .infinity)

                Spacer()

                Text(subtitleText)
                    .font(AppFont.title1Bold)
                    .foregroundStyle(
                        Color.textSecondaryWhite
                    )
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment:
                            phase == .picked
                            ? .leading
                            : .center
                    )
                    .padding(.horizontal, 4)

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 64)
        }
        .onAppear {
            startDate = Date()

            Task {
                // Durasi animasi muter-muter
                try? await Task.sleep(
                    nanoseconds: 3_000_000_000
                )

                frozenProgress =
                    Date()
                    .timeIntervalSince(
                        startDate
                    )
                    * 0.75

                withAnimation(
                    .spring(
                        response: 0.7,
                        dampingFraction: 0.78
                    )
                ) {
                    phase = .picked
                }

                // Durasi layar
                // "2 Kartu ini terpilih..."
                try? await Task.sleep(
                    nanoseconds: 2_000_000_000
                )

                onFinished()
            }
        }
    }

    private var subtitleText: String {
        phase == .picked
        ? "2 Kartu ini terpilih untuk kalian pilih dan mainkan!"
        : "Mengacak Kartu..."
    }

    private var choiceCards: [ChoiceCard] {
        cards.enumerated().map { _, card in
            ChoiceCard(
                id: card.id,
                topicID: card.topicID,
                title: topicName(
                    for: card.topicID
                ),
                symbol: "",
                color: Color.topicColor(
                    for: card.topicID
                )
            )
        }
    }

    private var pickedChoiceCards: [ChoiceCard] {
        pickedCards.compactMap { pickedCard in
            choiceCards.first {
                $0.id == pickedCard.id
            }
        }
    }

    // Filter dan prioritaskan kartu terpilih
    // agar masuk 10 teratas.
    private var displayCards: [ChoiceCard] {
        var guaranteedCards =
            pickedChoiceCards

        let remainingCards =
            choiceCards.filter { card in
                !guaranteedCards.contains {
                    $0.id == card.id
                }
            }

        guaranteedCards.append(
            contentsOf: remainingCards
        )

        return Array(
            guaranteedCards.prefix(10)
        )
    }

    private func placement(
        for index: Int,
        card: ChoiceCard,
        progress: Double
    ) -> CardPlacement {
        if phase == .picked {
            if pickedChoiceCards.first?.id
                == card.id {
                return CardPlacement(
                    x: -88,
                    y: 0,
                    scale: 1.45,
                    opacity: 1,
                    blur: 0,
                    flip: 0,
                    tilt: -8,
                    zIndex: 20
                )
            }

            if pickedChoiceCards
                .dropFirst()
                .first?
                .id == card.id {
                return CardPlacement(
                    x: 88,
                    y: 0,
                    scale: 1.45,
                    opacity: 1,
                    blur: 0,
                    flip: 0,
                    tilt: 8,
                    zIndex: 20
                )
            }

            return CardPlacement(
                x: 0,
                y: 40,
                scale: 0.55,
                opacity: 0,
                blur: 6,
                flip: 80,
                tilt: 0,
                zIndex: 0
            )
        }

        let count = Double(
            min(
                displayCards.count,
                10
            )
        )

        let angle =
            (
                (Double(index) / count)
                + progress
            )
            * 2.0
            * .pi

        let depth = sin(angle)

        let normalizedDepth =
            (depth + 1) / 2

        return CardPlacement(
            x: cos(angle) * 120,
            y: depth * 42,
            scale:
                0.68
                + normalizedDepth * 0.48,
            opacity:
                0.35
                + normalizedDepth * 0.65,
            blur:
                (1 - normalizedDepth)
                * 2.2,
            flip:
                cos(angle) * 58,
            tilt:
                cos(angle) * 10,
            zIndex:
                normalizedDepth
        )
    }

    private func topicName(
        for topicID: Int
    ) -> String {
        Topics.all.first {
            $0.id == topicID
        }?.name ?? "Topic \(topicID)"
    }
}

// MARK: - Carousel Picking View

private struct CarouselPickingView: View {
    let cards: [ChoiceCard]
    let phase: PickingPhase
    let pickedCards: [ChoiceCard]
    let startDate: Date
    let frozenProgress: Double

    let placement: (
        Int,
        ChoiceCard,
        Double
    ) -> CardPlacement

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed =
                timeline.date
                .timeIntervalSince(
                    startDate
                )

            let progress =
                phase == .picked
                ? frozenProgress
                : elapsed * 0.75

            ZStack {
                ForEach(
                    Array(
                        cards.enumerated()
                    ),
                    id: \.element.id
                ) { index, card in
                    let cardPlacement =
                        placement(
                            index,
                            card,
                            progress
                        )

                    MiniSpinningCard(
                        card: card,
                        isSelected: false
                    )
                    .scaleEffect(
                        cardPlacement.scale
                    )
                    .opacity(
                        cardPlacement.opacity
                    )
                    .blur(
                        radius:
                            cardPlacement.blur
                    )
                    .rotation3DEffect(
                        .degrees(
                            cardPlacement.flip
                        ),
                        axis: (
                            x: 0,
                            y: 1,
                            z: 0
                        ),
                        perspective: 0.65
                    )
                    .rotationEffect(
                        .degrees(
                            cardPlacement.tilt
                        )
                    )
                    .offset(
                        x: cardPlacement.x,
                        y: cardPlacement.y
                    )
                    .zIndex(
                        cardPlacement.zIndex
                    )
                    .animation(
                        .spring(
                            response: 0.65,
                            dampingFraction: 0.78
                        ),
                        value: phase
                    )
                }
            }
        }
    }
}

// MARK: - Safe Array Access

private extension Array {
    subscript(
        safe index: Int
    ) -> Element? {
        indices.contains(index)
        ? self[index]
        : nil
    }
}

// MARK: - Previews

#Preview("Would You Rather - Full Flow") {
    let container = try! ModelContainer(
        for:
            CardModel.self,
            SessionModel.self,
        configurations:
            ModelConfiguration(
                isStoredInMemoryOnly: true
            )
    )

    let context =
        container.mainContext

    // Simulate topics selected by user.
    let selectedTopicIDs = Array(
        Topics.all
            .shuffled()
            .prefix(10)
            .map(\.id)
    )

    // One dummy card
    // for each selected topic.
    for topicID in selectedTopicIDs {
        let card = CardModel(
            topicID: topicID,
            question:
                "Dummy question for topic \(topicID)"
        )

        context.insert(card)
    }

    return WouldYouRatherView(
        topicIDs: selectedTopicIDs
    )
    .modelContainer(container)
}

private struct WouldYouRatherSelectionPreview: View {
    @State private var selectedCardID: UUID?

    private let cards = [
        CardModel(
            topicID: Topics.all[0].id,
            question: "Dummy question"
        ),
        CardModel(
            topicID: Topics.all[1].id,
            question: "Dummy question"
        )
    ]

    var body: some View {
        WouldYouRatherSelectionView(
            cards: cards,
            selectedCardID: $selectedCardID,
            onConfirm: {},
            onDismiss: {}
        )
    }
}

#Preview("Bahas yang mana dulu?") {
    WouldYouRatherSelectionPreview()
}
