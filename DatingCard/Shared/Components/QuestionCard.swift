//
//  QuestionCard.swift
//  DatingCard
//

import SwiftUI

struct QuestionCard: View {
    let question: String

    var body: some View {
        Text(question)
            .font(AppFont.title3Regular)
            .foregroundStyle(Color.textPrimary)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(Spacing.lg)
            .background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
            .overlay {
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(Color.border, lineWidth: 1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Kartu pertanyaan")
            .accessibilityValue(question)
            .frame(width: 300, height: 475)
    }
}

#Preview {
    QuestionCard(
        question: "Jika kamu harus memperkenalkan dirimu tanpa menyebut pekerjaan, jurusan, atau hobi, apa yang akan kamu katakan?"
    )
//    .frame(width: 300, height: 475)
    .padding(Spacing.lg)
    .background(Color.bgPrimary)
}
