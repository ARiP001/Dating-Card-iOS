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
                Text(question)
                    .font(AppFont.title3Bold)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.leading)
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
}

#Preview {
    QuestionCard(
        question: "Jika kamu harus memperkenalkan dirimu tanpa menyebut pekerjaan, jurusan, atau hobi, apa yang akan kamu katakan?",
        topicID: 2
    )
    .padding(Spacing.lg)
    .background(Color.bgPrimary)
}
