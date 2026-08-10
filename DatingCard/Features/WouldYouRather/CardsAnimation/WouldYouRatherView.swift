import SwiftUI

struct WouldYouRatherView: View {
    let choices: [ChoiceCard]
    let onChoiceSelected: () -> Void

    @State private var selectedChoiceID: UUID?
    @State private var isOpeningPack = false

    var body: some View {
        VStack(spacing: 22) {
            Text("Would You Rather")
                .font(.largeTitle.bold())

            VStack(spacing: 18) {
                ForEach(choices) { choice in
                    Button {
                        openPack(choice)
                    } label: {
                        ZStack {
                            PackChoiceCard(choice: choice)
                                .scaleEffect(selectedChoiceID == choice.id && isOpeningPack ? 0.92 : 1)
                                .opacity(selectedChoiceID == choice.id && isOpeningPack ? 0.25 : 1)

                            if selectedChoiceID == choice.id {
                                PackBurstAnimation(isOpening: isOpeningPack, color: choice.color)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(isOpeningPack)
                }
            }
        }
        .padding(24)
    }

    private func openPack(_ choice: ChoiceCard) {
        selectedChoiceID = choice.id

        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            isOpeningPack = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            onChoiceSelected()
        }
    }
}

struct PackChoiceCard: View {
    let choice: ChoiceCard

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: choice.symbol)
                .font(.system(size: 58, weight: .semibold))

            Text(choice.title)
                .font(.title.bold())
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 210)
        .background(choice.color)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.16), radius: 14, x: 0, y: 8)
    }
}

struct PackBurstAnimation: View {
    let isOpening: Bool
    let color: Color

    private let cardCount = 9

    var body: some View {
        ZStack {
            ForEach(0..<cardCount, id: \.self) { index in
                BurstCard(color: color, index: index)
                    .offset(
                        x: isOpening ? xOffset(for: index) : 0,
                        y: isOpening ? yOffset(for: index) : 0
                    )
                    .rotationEffect(.degrees(isOpening ? rotation(for: index) : 0))
                    .scaleEffect(isOpening ? scale(for: index) : 0.25)
                    .opacity(isOpening ? 1 : 0)
                    .animation(
                        .spring(response: 0.75, dampingFraction: 0.72)
                            .delay(Double(index) * 0.035),
                        value: isOpening
                    )
            }

            Image(systemName: "sparkles")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.yellow)
                .scaleEffect(isOpening ? 1.4 : 0.2)
                .opacity(isOpening ? 1 : 0)
                .animation(.easeOut(duration: 0.45), value: isOpening)
        }
        .frame(height: 210)
    }

    private func xOffset(for index: Int) -> CGFloat {
        [-120, -80, -40, 0, 45, 85, 125, -20, 70][index]
    }

    private func yOffset(for index: Int) -> CGFloat {
        [-120, -165, -210, -185, -220, -170, -125, -250, -250][index]
    }

    private func rotation(for index: Int) -> Double {
        [-28, -18, -8, 4, 12, 22, 32, -35, 35][index]
    }

    private func scale(for index: Int) -> CGFloat {
        index == 7 || index == 8 ? 0.72 : 0.62
    }
}

struct BurstCard: View {
    let color: Color
    let index: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.white)
            .frame(width: 58, height: 82)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 3)
            }
            .overlay {
                Image(systemName: symbolName)
                    .font(.title3.bold())
                    .foregroundStyle(color)
            }
            .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 5)
    }

    private var symbolName: String {
        let symbols = [
            "star.fill",
            "bolt.fill",
            "heart.fill",
            "sparkles",
            "moon.fill",
            "sun.max.fill",
            "flame.fill",
            "seal.fill",
            "diamond.fill"
        ]

        return symbols[index % symbols.count]
    }
}
