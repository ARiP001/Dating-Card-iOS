//
//  SessionModel.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 10/08/26.
//

import Foundation
import SwiftData

@Model
final class SessionModel {
    var id: UUID
    var isContinue: Bool

    @Relationship
    var pickedCards: [CardModel]

    @Relationship
    var currentPackCards: [CardModel]

    var lastTopicID: String?
    var lastIndex: Int?

    init(
        id: UUID = UUID(),
        isContinue: Bool = false,
        pickedCards: [CardModel] = [],
        currentPackCards: [CardModel] = [],
        lastTopicID: String? = nil,
        lastIndex: Int? = nil
    ) {
        self.id = id
        self.isContinue = isContinue
        self.pickedCards = pickedCards
        self.currentPackCards = currentPackCards
        self.lastTopicID = lastTopicID
        self.lastIndex = lastIndex
    }
}
