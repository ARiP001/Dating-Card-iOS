//
//  HistoryView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 11/08/26.
//

import SwiftUI

struct HistoryView: View {
    @State private var selectedSession: HistorySession?

    private let sessions = HistorySession.samples

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.md) {
                Text("Kumpulan Ceritamu")
                    .font(AppFont.title2Bold)
                    .foregroundStyle(Color.textPrimary)
                    .padding(.bottom, Spacing.sm)

                ForEach(sessions) { session in
                    HistorySessionCard(
                        title: session.title,
                        date: session.date
                    ) {
                        selectedSession = session
                    }
                }
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.top, Spacing.xxl)
            .padding(.bottom, Spacing.lg)
        }
        .background(Color.bgPrimary.ignoresSafeArea())
        .sheet(item: $selectedSession) { session in
            HistorySessionDetailView(session: session)
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(Radius.xl)
            .presentationBackground(Color.bgCard)
        }
    }
}

private struct HistorySessionDetailView: View {
    let session: HistorySession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.lg)

            questionDeck

            details
                .padding(.top, Spacing.lg)

            Spacer(minLength: Spacing.lg)

            AppButton(title: "Bergantian") { }
                .padding(.bottom, Spacing.lg)
        }
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.bgCard)
    }

    private var header: some View {
        ZStack {
            Text(session.title)
                .font(AppFont.bodyBold)
                .foregroundStyle(Color.textPrimary)
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)

            HStack {
                iconButton(systemName: "pencil")

                Spacer()

                iconButton(systemName: "xmark") {
                    dismiss()
                }
            }
        }
    }

    private var questionDeck: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: Spacing.md) {
                ForEach(session.cards) { card in
                    QuestionCard(
                        question: card.question,
                        topicID: card.topicID
                    )
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, Spacing.xs, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            VStack(spacing: 0) {
                Divider()

                HStack {
                    Text("Cerita yang terbuka")
                        .font(AppFont.bodyRegular)
                        .foregroundStyle(Color.textPrimary)

                    Spacer()

                    Text("\(session.openCardsCount) Kartu")
                        .font(AppFont.bodyBold)
                        .foregroundStyle(Color.textPrimary)
                }
                .padding(.vertical, Spacing.md)

                Divider()
            }

            Text(session.summary)
                .font(AppFont.bodyRegular)
                .foregroundStyle(Color.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func iconButton(
        systemName: String,
        action: @escaping () -> Void = { }
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title3.weight(.medium))
                .foregroundStyle(Color.textPrimary)
                .frame(width: 48, height: 48)
                .background(Color.surfaceSecondary)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(systemName == "xmark" ? "Tutup" : "Edit")
    }
}

private struct HistorySession: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let date: String
    let cards: [HistoryQuestion]
    let openCardsCount: Int
    let summary: String

    static let samples: [HistorySession] = [
        HistorySession(
            title: "Beach trip with her",
            date: "21 Juli 2026",
            cards: makeCards(
                topics: Array(Topics.all.prefix(5))
            ),
            openCardsCount: 12,
            summary: "Kamu masih memiliki topik untuk dibicarakan dari sesi ini, kamu bisa melanjutkan sesi ini."
        ),
        HistorySession(
            title: "Cafe Hangout",
            date: "13 Juli 2026",
            cards: makeCards(
                topics: Array(Topics.all.suffix(5))
            ),
            openCardsCount: 15,
            summary: "Masih banyak yang belum sempat diceritakan. Yuk, main lagi dan lihat ke mana obrolannya membawa kalian."
        )
    ]

    private static func makeCards(topics: [TopicModel]) -> [HistoryQuestion] {
        topics.enumerated().map { index, topic in
            HistoryQuestion(
                topicID: topic.id,
                question: makeQuestion(
                    topic: topic,
                    variant: index
                )
            )
        }
    }

    private static func makeQuestion(topic: TopicModel, variant: Int) -> String {
        let topicName = topic.name.lowercased()

        switch variant {
        case 0:
            return "Jika kamu harus memperkenalkan dirimu tanpa menyebut pekerjaan, jurusan, atau hobi, apa yang akan kamu katakan?"
        case 1:
            return "Ceritakan satu hal kecil yang paling sering membuatmu tersenyum belakangan ini."
        case 2:
            return "Kalau kamu sedang membahas \(topicName), bagian mana yang paling ingin kamu ceritakan duluan?"
        case 3:
            return "Apa pengalaman yang paling membentuk caramu melihat \(topicName)?"
        default:
            return "Kalau kalian punya waktu lama untuk membahas \(topicName), hal apa yang ingin kamu buka dulu?"
        }
    }
}

private struct HistoryQuestion: Identifiable, Equatable {
    let id = UUID()
    let topicID: Int
    let question: String
}

#Preview {
    HistoryView()
}
