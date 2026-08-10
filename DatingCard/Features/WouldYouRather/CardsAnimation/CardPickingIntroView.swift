import SwiftUI

struct CardPickingIntroView: View {
    let cards: [ChoiceCard]
    let onFinished: ([ChoiceCard]) -> Void

    @State private var phase: PickingPhase = .combiningDecks
    @State private var shuffleStep = 0
    @State private var pickedCards: [ChoiceCard] = []
    @State private var startDate = Date()
    @State private var frozenProgress: Double = 0
    @State private var isStartingCarousel = false
    @State private var shuffleLoopTask: Task<Void, Never>?
    @State private var isShuffleReversing = false

    var body: some View {
        ZStack {
            if phase == .combiningDecks {
                Color.white.ignoresSafeArea()
            } else {
                Color(.systemGroupedBackground).ignoresSafeArea()
            }

            VStack(spacing: 28) {
                Text(titleText)
                    .font(phase == .combiningDecks ? .title2.bold() : .largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 12)

                ZStack {
                    if phase == .combiningDecks {
                        OneByOneShuffleView(
                            shuffleStep: shuffleStep,
                            isReversing: isShuffleReversing
                        )
                        .transition(.opacity)
                    } else {
                        CarouselPickingView(
                            cards: cards,
                            phase: phase,
                            pickedCards: pickedCards,
                            startDate: startDate,
                            frozenProgress: frozenProgress,
                            placement: placement
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(height: 520)

                if phase == .combiningDecks {
                    Button {
                        startCarouselPicking()
                    } label: {
                        HStack(spacing: 10) {
                            if isStartingCarousel {
                                ProgressView().tint(.white)
                            }

                            Text(isStartingCarousel ? "Mengacak kartu..." : "Kami berdua siap")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .disabled(isStartingCarousel)
                    .padding(.horizontal, 12)
                } else {
                    Text(subtitleText)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(24)
        }
        .onAppear {
            prepareLoopingShuffle()
        }
        .onDisappear {
            shuffleLoopTask?.cancel()
        }
    }

    private var titleText: String {
        switch phase {
        case .combiningDecks:
            return "Letakkan HP di tempat yang dapat kalian berdua lihat bersama"
        case .spinning:
            return "Picking Cards"
        case .picked:
            return "Your Pair"
        }
    }

    private var subtitleText: String {
        switch phase {
        case .combiningDecks:
            return ""
        case .spinning:
            return "Choosing your cards..."
        case .picked:
            return "These two become your Would You Rather."
        }
    }

    private func prepareLoopingShuffle() {
        phase = .combiningDecks
        isStartingCarousel = false
        shuffleStep = 0
        pickedCards = Array(cards.shuffled().prefix(2))
        startShuffleLoop()
    }

    private func startShuffleLoop() {
        shuffleLoopTask?.cancel()

        shuffleLoopTask = Task {
            var step = 0
            var direction = 1

            while !Task.isCancelled {
                await MainActor.run {
                    isShuffleReversing = direction == -1

                    withAnimation(.spring(response: 0.48, dampingFraction: 0.72)) {
                        shuffleStep = step
                    }
                }

                if step == 8 || step == 0 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                } else {
                    try? await Task.sleep(nanoseconds: 220_000_000)
                }

                step += direction

                if step >= 8 {
                    step = 8
                    direction = -1
                } else if step <= 0 {
                    step = 0
                    direction = 1
                }
            }
        }
    }

    private func startCarouselPicking() {
        guard !isStartingCarousel else { return }

        isStartingCarousel = true
        shuffleLoopTask?.cancel()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            startDate = Date()

            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                phase = .spinning
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.35) {
            frozenProgress = Date().timeIntervalSince(startDate) * 0.75

            withAnimation(.spring(response: 0.7, dampingFraction: 0.78)) {
                phase = .picked
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.75) {
            onFinished(pickedCards)
        }
    }

    private func placement(for index: Int, card: ChoiceCard, progress: Double) -> CardPlacement {
        if phase == .picked {
            if pickedCards.first?.id == card.id {
                return CardPlacement(x: -88, y: 0, scale: 1.45, opacity: 1, blur: 0, flip: 0, tilt: -8, zIndex: 20)
            }

            if pickedCards.dropFirst().first?.id == card.id {
                return CardPlacement(x: 88, y: 0, scale: 1.45, opacity: 1, blur: 0, flip: 0, tilt: 8, zIndex: 20)
            }

            return CardPlacement(x: 0, y: 40, scale: 0.55, opacity: 0, blur: 6, flip: 80, tilt: 0, zIndex: 0)
        }

        let count = Double(min(cards.count, 10))
        let angle = ((Double(index) / count) + progress) * 2.0 * .pi
        let depth = sin(angle)
        let normalizedDepth = (depth + 1) / 2

        return CardPlacement(
            x: cos(angle) * 120,
            y: depth * 42,
            scale: 0.68 + normalizedDepth * 0.48,
            opacity: 0.35 + normalizedDepth * 0.65,
            blur: (1 - normalizedDepth) * 2.2,
            flip: cos(angle) * 58,
            tilt: cos(angle) * 10,
            zIndex: normalizedDepth
        )
    }
}

struct CarouselPickingView: View {
    let cards: [ChoiceCard]
    let phase: PickingPhase
    let pickedCards: [ChoiceCard]
    let startDate: Date
    let frozenProgress: Double
    let placement: (Int, ChoiceCard, Double) -> CardPlacement

    var body: some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let progress = phase == .picked ? frozenProgress : elapsed * 0.75

            ZStack {
                ForEach(Array(cards.prefix(10).enumerated()), id: \.element.id) { index, card in
                    let placement = placement(index, card, progress)

                    MiniSpinningCard(card: card, isSelected: pickedCards.contains(card) && phase == .picked)
                        .scaleEffect(placement.scale)
                        .opacity(placement.opacity)
                        .blur(radius: placement.blur)
                        .rotation3DEffect(
                            .degrees(placement.flip),
                            axis: (x: 0, y: 1, z: 0),
                            perspective: 0.65
                        )
                        .rotationEffect(.degrees(placement.tilt))
                        .offset(x: placement.x, y: placement.y)
                        .zIndex(placement.zIndex)
                        .animation(.spring(response: 0.65, dampingFraction: 0.78), value: phase)
                }
            }
        }
    }
}
