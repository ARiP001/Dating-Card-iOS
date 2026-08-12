//
//  IceBreakings.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 13/08/26.
//

import Foundation

struct IceBreakings {
    static func card(
        for sessionID: UUID,
        topicID: Int
    ) -> CardModel? {
        let prompts = promptsIceBreaking()
        guard !prompts.isEmpty else { return nil }

        // Stable for the same session and topic, including after resuming.
        let seed = sessionID.uuidString.utf8.reduce(topicID) {
            ($0 &* 31) &+ Int($1)
        }
        let index = Int(UInt(bitPattern: seed) % UInt(prompts.count))

        return CardModel(
            topicID: Topics.iceBreaking.id,
            question: prompts[index]
        )
    }

    private static func promptsIceBreaking() -> [String] {
        [
            "Kalau kamu bisa langsung jago satu skill baru sekarang juga, kamu pilih skill apa?",
            "Apa hal random yang belakangan ini bikin kamu ketawa sendiri?",
            "Kalau weekend kamu bebas total tanpa kewajiban apapun, biasanya ngapain?",
            "Ada nggak makanan yang orang lain suka tapi kamu nggak ngerti kenapa?",
            "Kalau kamu harus pindah ke kota lain besok, kota mana yang kamu pilih?",
            "Lagu apa yang belakangan ini paling sering kamu putar berulang-ulang?",
            "Kalau kamu punya waktu ekstra 1 jam tiap hari, mau dipakai buat apa?",
            "Ada kebiasaan kecil yang orang lain anggap aneh tapi kamu ngerasa itu normal?",
            "Kalau harus milih, kamu tipe orang yang suka rencana detail atau spontan aja?",
            "Apa hal simpel yang bikin mood kamu langsung membaik?"
        ]
    }
}
