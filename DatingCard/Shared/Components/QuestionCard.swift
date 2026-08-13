//
//  QuestionCard.swift
//  DatingCard
//
import SwiftUI

struct QuestionCard: View {
    let question: String
    let topicID: Int
    var showsQuestion = true
    var width: CGFloat = 300
    var height: CGFloat = 464
    var imageContext: TopicImageContext = .questionCard

    var body: some View {
        ZStack(alignment: .leading) {
            Color.topicColor(for: topicID)

            Image(topicID: topicID, context: imageContext)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()

            if showsQuestion {
                questionContent
                    .padding(Spacing.lg)
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
            .overlay {
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(Color.border, lineWidth: 1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Kartu pertanyaan")
            .accessibilityValue(question)
            .frame(width: width, height: height)
    }

    /// Beberapa kartu (misal perintah "Urutkan dari...") membawa daftar item
    /// di baris-baris setelah perintah utama. Bagian ini murni tampilan —
    /// baris pertama ditampilkan sebagai judul pertanyaan, sisanya sebagai
    /// daftar yang hanya dibaca. Tidak ada gesture, tap target, atau state
    /// pilihan apa pun yang ditambahkan di sini.
    @ViewBuilder
    private var questionContent: some View {
        let lines = question.components(separatedBy: "\n")

        if lines.count > 1, let prompt = lines.first {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(prompt)
                    .font(AppFont.title3Bold)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(lines.dropFirst().enumerated()), id: \.offset) { _, item in
                        Text(item)
                            .font(AppFont.bodyRegular)
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        } else {
            Text(question)
                .font(AppFont.title3Bold)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview("Pertanyaan biasa") {
    QuestionCard(
        question: "Jika kamu harus memperkenalkan dirimu tanpa menyebut pekerjaan, jurusan, atau hobi, apa yang akan kamu katakan?",
        topicID: 2
    )
    .padding(Spacing.lg)
    .background(Color.bgPrimary)
}

#Preview("Spot It") {
    QuestionCard(
        question: "Temukan benda berwarna biru di ruangan ini.",
        topicID: 2
    )
    .padding(Spacing.lg)
    .background(Color.bgPrimary)
}

#Preview("Ranking") {
    QuestionCard(
        question: """
        Urutkan dari yang paling menyebalkan:
        1. Internet lambat
        2. Baterai habis
        3. Lupa charger
        4. Salah kirim chat
        """,
        topicID: 2
    )
    .padding(Spacing.lg)
    .background(Color.bgPrimary)
}
