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
    var height: CGFloat = 475

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.topicColor(for: topicID)

            if showsQuestion {
                Text(question)
                    .font(AppFont.title3Regular)
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
        topicID: 1
    )
//    .frame(width: 300, height: 475)
    .padding(Spacing.lg)
    .background(Color.bgPrimary)
}
