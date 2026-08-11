//
//  Cards.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 10/08/26.
//

import Foundation

import Foundation

enum CardData {
    static func createAll() -> [CardModel] {
        [
            CardModel(
                topicID: Topics.all[0].id,
                question: "What's your ideal weekend?"
            ),
            CardModel(
                topicID: Topics.all[0].id,
                question: "What's something you could talk about for hours?"
            ),
            CardModel(
                topicID: Topics.all[1].id,
                question: "What's a childhood memory you still remember clearly?"
            ),
            CardModel(
                topicID: Topics.all[1].id,
                question: "What's a childhood memory you still remember clearly?222222"
            ),
            CardModel(
                topicID: Topics.all[1].id,
                question: "What's a childhood memory you still remember clearly?33333"
            )
        ]
    }
}
