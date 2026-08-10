//
//  CardModel.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 10/08/26.
//
import Foundation
import SwiftData

@Model
final class CardModel {
    var id: UUID
    var topicID: String
    var question: String
    var isPicked: Bool

    init(
        id: UUID = UUID(),
        topicID: String,
        question: String,
        isPicked: Bool = false
    ) {
        self.id = id
        self.topicID = topicID
        self.question = question
        self.isPicked = isPicked
    }
}
