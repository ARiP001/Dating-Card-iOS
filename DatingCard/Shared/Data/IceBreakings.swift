//
//  IceBreakings.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 13/08/26.
//

import Foundation

// MARK: - Model

enum IceBreakingTemplate {
    case plain(String)

    case fillIn(base: String, placeholder: String, options: [String])
    case ranking(prompt: String, itemSets: [[String]])

    func resolve(seed: Int) -> String {
        switch self {
        case let .plain(text):
            return text

        case let .fillIn(base, placeholder, options):
            guard !options.isEmpty else { return base }
            let index = Int(UInt(bitPattern: seed) % UInt(options.count))
            return base.replacingOccurrences(of: placeholder, with: options[index])

        case let .ranking(prompt, itemSets):
            guard !itemSets.isEmpty else { return prompt }
            let index = Int(UInt(bitPattern: seed) % UInt(itemSets.count))
            let numbered = itemSets[index]
                .enumerated()
                .map { "\($0.offset + 1). \($0.element)" }
                .joined(separator: "\n")
            return "\(prompt)\n\(numbered)"
        }
    }
}

// MARK: - IceBreakings

struct IceBreakings {
    static func card(
        for sessionID: UUID,
        topicID: Int
    ) -> CardModel? {
        let templates = allTemplates()
        guard !templates.isEmpty else { return nil }

        // Stable untuk session dan topik yang sama, termasuk setelah resume.
        let templateSeed = seed(for: sessionID, salt: topicID)
        let templateIndex = Int(UInt(bitPattern: templateSeed) % UInt(templates.count))
        let template = templates[templateIndex]

        // Seed turunan untuk memilih value/itemSet DI DALAM template,
        // supaya tidak selalu berkorelasi langsung dengan index template.
        let innerSeed = seed(for: sessionID, salt: topicID &* 31 &+ templateIndex)

        return CardModel(
            topicID: Topics.iceBreaking.id,
            question: template.resolve(seed: innerSeed)
        )
    }

    private static func seed(for sessionID: UUID, salt: Int) -> Int {
        sessionID.uuidString.utf8.reduce(salt) {
            ($0 &* 31) &+ Int($1)
        }
    }

    private static func allTemplates() -> [IceBreakingTemplate] {
        plainPrompts() + spotItPrompts() + rankingPrompts()
    }

    // MARK: - Plain

    private static func plainPrompts() -> [IceBreakingTemplate] {
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
        ].map { .plain($0) }
    }

    // MARK: - A. Spot It

    private static func spotItPrompts() -> [IceBreakingTemplate] {
        [
            .fillIn(
                base: "Temukan benda berwarna [colorname] di ruangan ini.",
                placeholder: "[colorname]",
                options: ["merah", "oranye", "kuning", "hijau", "biru", "ungu", "pink", "coklat", "putih", "hitam"]
            ),
            .fillIn(
                base: "Temukan benda dengan minimal [value] warna berbeda di ruangan ini.",
                placeholder: "[value]",
                options: ["2", "3"]
            ),
            .fillIn(
                base: "Temukan benda yang namanya dimulai dengan huruf [character] di ruangan ini.",
                placeholder: "[character]",
                options: ["A", "B", "C", "D", "E", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "R", "S", "T", "U", "W"]
            ),
            .fillIn(
                base: "Temukan benda yang namanya terdiri dari [value] suku kata di ruangan ini.",
                placeholder: "[value]",
                options: ["2", "3"]
            ),
            .fillIn(
                base: "Temukan benda dengan jumlah huruf [value] di ruangan ini.",
                placeholder: "[value]",
                options: ["4", "5", "6", "7 atau lebih"]
            ),
            .fillIn(
                base: "Temukan benda yang lebih [size] dari telapak tangan di ruangan ini.",
                placeholder: "[size]",
                options: ["kecil", "besar"]
            ),
            .fillIn(
                base: "Temukan benda paling [size] yang bisa kamu lihat di ruangan ini.",
                placeholder: "[size]",
                options: ["kecil", "besar", "tinggi", "pendek"]
            ),
            .fillIn(
                base: "Temukan sesuatu yang terbuat dari [material].",
                placeholder: "[material]",
                options: ["kayu", "logam", "kaca", "plastik", "kain"]
            ),
            .fillIn(
                base: "Temukan sesuatu berbentuk [shape] di ruangan ini.",
                placeholder: "[shape]",
                options: ["lingkaran", "segitiga", "persegi panjang"]
            )
        ]
    }

    // MARK: - B. Ranking

    private static func rankingPrompts() -> [IceBreakingTemplate] {
        [
            .ranking(
                prompt: "Urutkan dari yang paling menyebalkan:",
                itemSets: [
                    ["internet lambat", "baterai habis", "lupa charger", "salah kirim chat"],
                    ["kehujanan", "macet", "antre panjang", "lupa bawa dompet"],
                    ["typo di pesan penting", "salah mention orang", "salah kirim foto", "salah kirim voice note"],
                    ["notifikasi palsu", "iklan yang tidak bisa di-skip", "website loading lama", "update aplikasi mendadak"],
                    ["telat bangun", "salah turun transportasi", "kehabisan kuota", "HP lowbat saat di luar"],
                    ["kehilangan dompet", "kehilangan HP", "kehilangan kunci", "kehilangan earphone"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari paling menakutkan:",
                itemSets: [
                    ["presentasi", "ketemu mantan", "naik roller coaster", "telat bangun"],
                    ["public speaking", "wawancara kerja", "harus memulai percakapan dengan orang asing", "ketemu orang tua pasangan"],
                    ["HP mati saat traveling", "tersesat", "kehilangan koper", "kehilangan KTP/Paspor"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari paling bikin senang:",
                itemSets: [
                    ["makanan gratis", "gajian", "libur mendadak", "paket datang"],
                    ["dipuji", "ditraktir", "menang giveaway", "menemukan uang"],
                    ["tidur siang", "rebahan", "makan favorit", "nonton favorit"],
                    ["hujan saat tidur", "AC dingin dan selimut hangat", "kasur empuk", "tidur sepuasnya tanpa alarm"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari paling sulit ditolak:",
                itemSets: [
                    ["nasi goreng", "mie goreng", "ayam goreng", "bakso"],
                    ["pizza", "burger", "sushi", "pasta"],
                    ["cookies", "es krim", "cheesecake", "brownies"],
                    ["kopi", "teh", "matcha", "minuman coklat"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari paling ingin dikunjungi:",
                itemSets: [
                    ["Jepang", "Korea", "China", "Swiss"],
                    ["pantai", "gunung", "kota besar", "pedesaan"],
                    ["cruise", "road trip", "liburan resort", "wisata kota"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari paling menyakitkan:",
                itemSets: [
                    ["HP 1%", "WiFi mati", "lupa charger", "aplikasi error"],
                    ["chat tidak dibalas", "pesan hanya dibaca", "dibalas 'wkwk' aja", "dibalas stiker"],
                    ["salah upload story", "typo caption", "lupa mute microphone", "kamera menyala tanpa sadar"],
                    ["akun terkunci", "kehilangan akun", "lupa password", "logout semua device"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari paling seru:",
                itemSets: [
                    ["film", "serial", "anime", "reality show"],
                    ["konser", "bioskop", "game", "karaoke"],
                    ["TikTok", "Instagram", "YouTube", "Netflix"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari paling penting:",
                itemSets: [
                    ["tempat tidur", "WiFi", "AC", "kulkas"],
                    ["sendok", "gelas", "piring", "mangkuk"],
                    ["earphone", "internet", "HP", "charger"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari paling ingin dimiliki:",
                itemSets: [
                    ["bisa teleportasi/langsung berpindah tempat", "bisa terbang", "bisa membaca pikiran", "bisa mengendalikan waktu"],
                    ["tidak perlu tidur", "tidak perlu makan", "bisa berbicara semua bahasa", "punya ingatan sempurna"],
                    ["bisa menjadi tidak terlihat", "bisa berbicara dengan hewan", "bisa berjalan menembus dinding", "bisa mengendalikan cuaca"],
                    ["bisa menyembuhkan orang", "bisa melihat masa depan", "bisa kembali ke masa lalu", "bisa menggandakan diri"],
                    ["bisa memahami semua pelajaran dalam sekali baca", "bisa menguasai skill apa pun dalam sehari", "bisa mengingat semua yang pernah dipelajari", "bisa fokus kapan saja"]
                ]
            ),
            .ranking(
                prompt: "Urutkan dari yang paling memalukan:",
                itemSets: [
                    ["salah panggil nama", "tersandung", "salah dengar", "salah menyebut sesuatu dengan keras"],
                    ["melambaikan tangan ke orang yang ternyata bukan kenalanmu", "salah masuk ruangan", "salah duduk di meja orang", "salah antre"],
                    ["ketahuan mengintip seseorang", "ketahuan membaca chat di layar orang lain", "ketahuan mendengarkan percakapan orang lain", "ketahuan salah paham"],
                    ["alarm berbunyi saat presentasi", "nada dering keras di tempat umum", "video autoplay dengan volume penuh", "voice note terputar keras tanpa sengaja"],
                    ["mengirim pesan ke orang/grup yang salah", "salah kirim foto", "voice note terkirim tanpa sengaja", "kamera menyala tanpa sadar"],
                    ["menyapa orang yang salah", "salah mengira seseorang melambai ke kamu", "mengira seseorang memanggilmu padahal bukan", "mengira seseorang sedang berbicara denganmu"],
                    ["menjatuhkan sendok saat makan", "menumpahkan minuman", "saus mengenai baju", "makanan terselip di gigi lalu baru sadar berjam-jam kemudian"]
                ]
            )
        ]
    }
}
