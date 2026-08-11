//
//  SessionModel.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 10/08/26.

import Foundation
import SwiftData

@Model
final class SessionModel {
    var id: UUID
    var isContinue: Bool

    // Final topic pool for this session: the union of both users'
    // preferences after every hated topic has been removed.
    var selectedTopicIDs: [Int]

    // Topics that are still waiting to be played (a topic removed after all 5 question cards in its pack have been completed)
    var currentTopicIDs: [Int]

    @Relationship
    var pickedCards: [CardModel]
    
    var lastTopicID: Int?
    var lastIndex: Int?

    init(
        id: UUID = UUID(),
        isContinue: Bool = false,
        selectedTopicIDs: [Int] = [],
        currentTopicIDs: [Int] = [],
        pickedCards: [CardModel] = [],
        lastTopicID: Int? = nil,
        lastIndex: Int? = nil
    ) {
        self.id = id
        self.isContinue = isContinue
        self.selectedTopicIDs = selectedTopicIDs
        self.currentTopicIDs = currentTopicIDs
        self.pickedCards = pickedCards
        self.lastTopicID = lastTopicID
        self.lastIndex = lastIndex
    }
}
