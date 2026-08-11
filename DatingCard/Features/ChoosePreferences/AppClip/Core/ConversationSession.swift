//
//  ConversationSession.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import Foundation

struct ConversationSession: Codable, Identifiable, Equatable {
    let id: String

    let selectedTopics: [Int]
    let hatedTopics: [Int]

    let status: String

    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id

        case selectedTopics = "selected_topics"
        case hatedTopics = "hated_topics"

        case status

        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
