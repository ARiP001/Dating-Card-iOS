import SwiftUI

struct ContentViewCards: View {
    @State private var flow: AppFlow = .pickingCards

    @State private var allChoices: [ChoiceCard] = [
        ChoiceCard(title: "Explore", symbol: "location.north.circle.fill", color: .blue),
        ChoiceCard(title: "Dream", symbol: "moon.fill", color: .purple),
        ChoiceCard(title: "Create", symbol: "paintbrush.fill", color: .orange),
        ChoiceCard(title: "Rest", symbol: "bed.double.fill", color: .green),
        ChoiceCard(title: "Adventure", symbol: "map.fill", color: .pink),
        ChoiceCard(title: "Focus", symbol: "target", color: .indigo),
        ChoiceCard(title: "Laugh", symbol: "face.smiling.fill", color: .yellow),
        ChoiceCard(title: "Risk", symbol: "flame.fill", color: .red),
        ChoiceCard(title: "Connect", symbol: "person.2.fill", color: .teal),
        ChoiceCard(title: "Wonder", symbol: "sparkles", color: .cyan)
    ]

    @State private var wouldRatherChoices: [ChoiceCard] = []

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            switch flow {
            case .pickingCards:
                CardPickingIntroView(cards: allChoices) { pickedCards in
                    wouldRatherChoices = pickedCards

                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        flow = .wouldYouRather
                    }
                }

            case .wouldYouRather:
                WouldYouRatherView(choices: wouldRatherChoices) {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        flow = .tutorial
                    }
                }

            case .tutorial:
                TutorialView {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        flow = .cards
                    }
                }

            case .cards:
                NormalCardSwipeView {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        flow = .pickingCards
                    }
                }
            }
        }
    }
}

#Preview {
    ContentViewCards()
}
