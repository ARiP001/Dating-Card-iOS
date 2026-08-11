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
        Topics.all.flatMap { topic in
            prompts.map { prompt in
                CardModel(topicID: topic.id, question: prompt.replacingOccurrences(of: "%@", with: topic.name.lowercased()))
            }
        }
    }

    private static let prompts = [
        "Apa hal pertama yang ingin kamu ceritakan tentang %@?",
        "Pengalaman apa yang paling membentuk caramu melihat %@?",
        "Hal kecil apa tentang %@ yang akhir-akhir ini membuatmu tersenyum?",
        "Kalau punya waktu panjang untuk membahas %@, kamu ingin mulai dari mana?",
        "Apa satu hal tentang %@ yang ingin lebih dipahami oleh orang lain?"
    ]
}
