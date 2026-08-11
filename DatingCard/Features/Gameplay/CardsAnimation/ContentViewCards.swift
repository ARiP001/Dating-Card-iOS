import SwiftData
import SwiftUI

struct ContentViewCards: View {
    var body: some View {
        WouldYouRatherView(topicIDs: [1, 2, 3, 4, 5])
    }
}

#Preview {
    let container = try! ModelContainer(
        for: CardModel.self,
        SessionModel.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let context = container.mainContext

    [
        CardModel(topicID: 1, question: "Would you rather travel the world or stay in one place forever?"),
        CardModel(topicID: 2, question: "Would you rather know your future or change your past?"),
        CardModel(topicID: 3, question: "Would you rather live by the beach or in the mountains?"),
        CardModel(topicID: 4, question: "Would you rather have unlimited time or unlimited money?"),
        CardModel(topicID: 5, question: "Would you rather always say what you think or never speak again?")
    ].forEach {
        context.insert($0)
    }

    return ContentViewCards()
        .modelContainer(container)
}
