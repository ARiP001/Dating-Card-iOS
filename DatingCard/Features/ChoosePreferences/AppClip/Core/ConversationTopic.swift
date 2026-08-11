//
//  ConversationTopic.swift
//  DatingCard
//
//  Compatibility layer for the older App Clip flow. The canonical topic
//  catalogue now lives in Topics.swift.
//

import Foundation

typealias ConversationTopic = TopicModel

extension TopicModel {
    static var all: [TopicModel] {
        Topics.all
    }

    static func topic(for id: Int) -> TopicModel? {
        Topics.all.first { $0.id == id }
    }

    var title: String {
        name
    }

    var systemImage: String {
        "bubble.left.and.bubble.right.fill"
    }
}
