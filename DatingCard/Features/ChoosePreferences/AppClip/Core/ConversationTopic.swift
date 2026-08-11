//
//  ConversationTopic.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import Foundation

struct ConversationTopic: Identifiable, Hashable {
    let id: Int
    let title: String
    let systemImage: String
}

extension ConversationTopic {
    static let all: [ConversationTopic] = [
        ConversationTopic(
            id: 1,
            title: "Hobbies",
            systemImage: "gamecontroller"
        ),
        ConversationTopic(
            id: 2,
            title: "Future",
            systemImage: "sparkles"
        ),
        ConversationTopic(
            id: 3,
            title: "Travel",
            systemImage: "airplane"
        ),
        ConversationTopic(
            id: 4,
            title: "Childhood",
            systemImage: "figure.child"
        ),
        ConversationTopic(
            id: 5,
            title: "Food",
            systemImage: "fork.knife"
        ),
        ConversationTopic(
            id: 6,
            title: "Movies",
            systemImage: "film"
        )
    ]

    static func topic(for id: Int) -> ConversationTopic? {
        all.first { $0.id == id }
    }
}
