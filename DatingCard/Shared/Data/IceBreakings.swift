//
//  IceBreakings.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 13/08/26.
//

struct IceBreakings {
    static func createIceBreakingCards() -> [CardModel] {
            promptsIceBreaking().map { prompt in
                CardModel(
                    topicID: 0,
                    question: prompt
                )
            }
        }

        private static func promptsIceBreaking() -> [String] {
            return [
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
