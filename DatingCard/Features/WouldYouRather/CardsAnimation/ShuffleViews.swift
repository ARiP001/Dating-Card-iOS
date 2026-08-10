import SwiftUI

struct OneByOneShuffleView: View {
    let shuffleStep: Int
    let isReversing: Bool

    private let cardCount = 8
    private let cardWidth: CGFloat = 132
    private let cardHeight: CGFloat = 186
    private let cornerPadding: CGFloat = 18

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                ForEach(0..<cardCount, id: \.self) { index in
                    let hasArrived = shuffleStep > index
                    let isCurrent = shuffleStep == index

                    SingleShuffleCard()
                        .offset(
                            x: topCardX(index: index, width: width, hasArrived: hasArrived),
                            y: topCardY(index: index, height: height, hasArrived: hasArrived)
                        )
                        .rotationEffect(.degrees(topRotation(index: index, hasArrived: hasArrived)))
                        .scaleEffect(isCurrent ? 1.04 : 1)
                        .opacity(shuffleStep >= index ? 1 : 0)
                        .zIndex(cardZIndex(index: index, isBottomCard: false))
                        .animation(.spring(response: 0.5, dampingFraction: 0.74), value: shuffleStep)

                    SingleShuffleCard()
                        .offset(
                            x: bottomCardX(index: index, width: width, hasArrived: hasArrived),
                            y: bottomCardY(index: index, height: height, hasArrived: hasArrived)
                        )
                        .rotationEffect(.degrees(bottomRotation(index: index, hasArrived: hasArrived)))
                        .scaleEffect(isCurrent ? 1.04 : 1)
                        .opacity(shuffleStep >= index ? 1 : 0)
                        .zIndex(cardZIndex(index: index, isBottomCard: true))
                        .animation(.spring(response: 0.55, dampingFraction: 0.76), value: shuffleStep)
                }
            }
            .frame(width: width, height: height)
        }
    }

    private func topCardX(index: Int, width: CGFloat, hasArrived: Bool) -> CGFloat {
        if hasArrived {
            return CGFloat(index - 4) * 4
        }

        return width / 2 - cardWidth / 2 - cornerPadding
    }

    private func topCardY(index: Int, height: CGFloat, hasArrived: Bool) -> CGFloat {
        if hasArrived {
            return CGFloat(index) * -3
        }

        return -height / 2 + cardHeight / 2 + cornerPadding
    }

    private func bottomCardX(index: Int, width: CGFloat, hasArrived: Bool) -> CGFloat {
        if hasArrived {
            return CGFloat(index) * 5 - 8
        }

        return -width / 2 + cardWidth / 2 + cornerPadding
    }

    private func bottomCardY(index: Int, height: CGFloat, hasArrived: Bool) -> CGFloat {
        if hasArrived {
            return CGFloat(index) * -3 + 8
        }

        return height / 2 - cardHeight / 2 - cornerPadding
    }

    private func topRotation(index: Int, hasArrived: Bool) -> Double {
        if hasArrived {
            return Double(index - 4) * 2.5
        }

        return 22
    }

    private func bottomRotation(index: Int, hasArrived: Bool) -> Double {
        if hasArrived {
            return Double(index) * 2.6 - 7
        }

        return 24
    }

    private func cardZIndex(index: Int, isBottomCard: Bool) -> Double {
        if isReversing {
            let reverseBase = Double((cardCount - index) * 2)
            return reverseBase + (isBottomCard ? 1 : 0)
        }

        return Double(index * 2 + (isBottomCard ? 1 : 0))
    }
}

struct SingleShuffleCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(
                LinearGradient(
                    colors: [
                        Color(.systemGray5),
                        Color(.systemGray6)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 132, height: 186)
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(.systemGray3).opacity(0.45), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.14), radius: 12, x: 0, y: 8)
    }
}

struct MiniSpinningCard: View {
    let card: ChoiceCard
    let isSelected: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(card.color)

            RoundedRectangle(cornerRadius: 14)
                .stroke(.white.opacity(0.55), lineWidth: 2)

            VStack(spacing: 8) {
                Image(systemName: card.symbol)
                    .font(.title2.bold())

                Text(card.title)
                    .font(.caption.bold())
            }
            .foregroundStyle(.white)

            if isSelected {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.yellow, lineWidth: 4)
                    .shadow(color: .yellow.opacity(0.8), radius: 14)
            }
        }
        .frame(width: 78, height: 110)
        .shadow(
            color: .black.opacity(isSelected ? 0.28 : 0.16),
            radius: isSelected ? 14 : 8,
            x: 0,
            y: isSelected ? 8 : 5
        )
    }
}
