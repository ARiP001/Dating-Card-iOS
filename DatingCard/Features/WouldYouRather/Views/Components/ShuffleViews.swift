import SwiftUI

struct OneByOneShuffleView: View {
    let shuffleStep: Int
    let isReversing: Bool
    var topicIDs: [Int] = Topics.all.map(\.id).shuffled()

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

                    SingleShuffleCard(topicID: topicID(for: index, offset: 0))
                        .offset(
                            x: topCardX(index: index, width: width, hasArrived: hasArrived),
                            y: topCardY(index: index, height: height, hasArrived: hasArrived)
                        )
                        .rotationEffect(.degrees(topRotation(index: index, hasArrived: hasArrived)))
                        .scaleEffect(isCurrent ? 1.04 : 1)
                        .opacity(shuffleStep >= index ? 1 : 0)
                        .zIndex(cardZIndex(index: index, isBottomCard: false))
                        .animation(.spring(response: 0.5, dampingFraction: 0.74), value: shuffleStep)

                    SingleShuffleCard(topicID: topicID(for: index, offset: cardCount))
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

    private func topicID(for index: Int, offset: Int) -> Int {
        guard !topicIDs.isEmpty else { return 1 }

        return topicIDs[(index + offset) % topicIDs.count]
    }
}

struct SingleShuffleCard: View {
    let topicID: Int

    var body: some View {
        QuestionCard(
            question: "",
            topicID: topicID,
            showsQuestion: false,
            width: 132,
            height: 186
        )
            .shadow(color: .black.opacity(0.14), radius: 12, x: 0, y: 8)
    }
}

struct MiniSpinningCard: View {
    let card: ChoiceCard
    let isSelected: Bool

    var body: some View {
        ZStack {
            QuestionCard(
                question: "",
                topicID: card.topicID ?? 1,
                showsQuestion: false,
                width: 78,
                height: 110
            )

            if isSelected {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.yellow, lineWidth: 4)
                    .shadow(color: .yellow.opacity(0.8), radius: 14)
            }
        }
        .shadow(
            color: .black.opacity(isSelected ? 0.28 : 0.16),
            radius: isSelected ? 14 : 8,
            x: 0,
            y: isSelected ? 8 : 5
        )
    }
}
