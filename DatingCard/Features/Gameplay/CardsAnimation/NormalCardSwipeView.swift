import SwiftUI

struct NormalCardSwipeView: View {
    let onOpenAnotherPack: () -> Void

    @State private var cards: [SwipeCard] = [
        SwipeCard(question: "What is one thing you want to learn this year?", color: .blue),
        SwipeCard(question: "What habit would make your life better?", color: .orange),
        SwipeCard(question: "What is something you are proud of?", color: .purple),
        SwipeCard(question: "Who do you want to reconnect with?", color: .green)
    ]

    @State private var swipeRequest: SwipeRequest?

    var body: some View {
        VStack(spacing: 24) {
            Text("Question")
                .font(.title.bold())

            ZStack {
                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                    SwipeableCardView(
                        card: card,
                        swipeRequest: index == cards.count - 1 ? swipeRequest : nil
                    ) {
                        remove(card)
                    }
                    .stacked(at: index, in: cards.count)
                    .allowsHitTesting(index == cards.count - 1)
                }

                if cards.isEmpty {
                    EmptyPackView {
                        onOpenAnotherPack()
                    }
                }
            }
            .frame(height: 520)

            HStack(spacing: 28) {
                Button {
                    swipeTopCard(.left)
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.bold())
                        .frame(width: 64, height: 64)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                        .foregroundStyle(.red)
                }

                Button {
                    swipeTopCard(.right)
                } label: {
                    Image(systemName: "checkmark")
                        .font(.title2.bold())
                        .frame(width: 64, height: 64)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 8)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(24)
    }

    private func remove(_ card: SwipeCard) {
        cards.removeAll { $0.id == card.id }
        swipeRequest = nil
    }

    private func swipeTopCard(_ direction: SwipeDirection) {
        guard !cards.isEmpty else { return }
        swipeRequest = SwipeRequest(direction: direction)
    }
}

struct SwipeableCardView: View {
    let card: SwipeCard
    let swipeRequest: SwipeRequest?
    let onRemove: () -> Void

    @State private var offset: CGSize = .zero

    private let swipeThreshold: CGFloat = 120

    var body: some View {
        VStack {
            Spacer()

            Text(card.question)
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding()

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 500)
        .background(card.color)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 10)
        .overlay(alignment: .topLeading) {
            swipeLabel("ANSWERED", color: .green, opacity: likeOpacity)
        }
        .overlay(alignment: .topTrailing) {
            swipeLabel("SKIPPED", color: .red, opacity: nopeOpacity)
        }
        .offset(offset)
        .rotationEffect(.degrees(Double(offset.width / 18)))
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.translation
                }
                .onEnded { value in
                    handleDragEnd(value.translation)
                }
        )
        .onChange(of: swipeRequest) { _, request in
            guard let request else { return }
            swipe(request.direction)
        }
    }

    private var likeOpacity: Double {
        min(Double(offset.width / swipeThreshold), 1)
    }

    private var nopeOpacity: Double {
        min(Double(-offset.width / swipeThreshold), 1)
    }

    private func swipeLabel(_ text: String, color: Color, opacity: Double) -> some View {
        Text(text)
            .font(.headline.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(24)
            .opacity(opacity)
            .rotationEffect(.degrees(text == "ANSWERED" ? -12 : 12))
    }

    private func handleDragEnd(_ translation: CGSize) {
        if translation.width > swipeThreshold {
            swipe(.right)
        } else if translation.width < -swipeThreshold {
            swipe(.left)
        } else {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                offset = .zero
            }
        }
    }

    private func swipe(_ direction: SwipeDirection) {
        let x: CGFloat = direction == .right ? 900 : -900

        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
            offset = CGSize(width: x, height: 90)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            onRemove()
        }
    }
}

struct EmptyPackView: View {
    let onOpenAnotherPack: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Text("Cards in this pack already run out")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            EmptyPackIllustration()
                .frame(width: 220, height: 260)

            Button {
                onOpenAnotherPack()
            } label: {
                Text("Open another pack")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
            }
            .buttonStyle(.borderedProminent)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 24)
        }
    }
}

struct EmptyPackIllustration: View {
    var body: some View {
        ZStack {
            EmptyDottedCard(rotation: -18, xOffset: -46, yOffset: 12)
            EmptyDottedCard(rotation: 0, xOffset: 0, yOffset: -6)
            EmptyDottedCard(rotation: 18, xOffset: 46, yOffset: 12)
        }
        .frame(width: 240, height: 260)
    }
}

struct EmptyDottedCard: View {
    let rotation: Double
    let xOffset: CGFloat
    let yOffset: CGFloat

    var body: some View {
        Rectangle()
            .stroke(
                .secondary.opacity(0.55),
                style: StrokeStyle(
                    lineWidth: 4,
                    lineCap: .round,
                    dash: [10, 12]
                )
            )
            .frame(width: 110, height: 170)
            .rotationEffect(.degrees(rotation), anchor: .bottom)
            .offset(x: xOffset, y: yOffset)
    }
}
