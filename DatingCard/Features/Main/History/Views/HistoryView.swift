//
//  HistoryView.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 11/08/26.
//

import SwiftUI

struct HistoryView: View {
    @State private var selectedSession: HistorySession?
    @State private var sessions = HistorySession.samples

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
            NavigationStack {
                HistorySessionDetailView(
                    session: session,
                    onTitleChanged: { newTitle in
                        updateTitle(
                            newTitle,
                            for: session.id
                        )
                    }
                )
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(Radius.xl)
            .presentationBackground(Color.bgCard)
        }
    }

    private func updateTitle(
        _ title: String,
        for sessionID: UUID
    ) {
        guard let index = sessions.firstIndex(
            where: { $0.id == sessionID }
        ) else {
            return
        }

        sessions[index].title = title
        selectedSession = sessions[index]
    }
}

private struct HistorySessionDetailView: View {
    let session: HistorySession
    let onTitleChanged: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var draftTitle: String
    @State private var isShowingTitleEditor = false

    init(
        session: HistorySession,
        onTitleChanged: @escaping (String) -> Void
    ) {
        self.session = session
        self.onTitleChanged = onTitleChanged
        _title = State(initialValue: session.title)
        _draftTitle = State(initialValue: session.title)
    }

    var body: some View {
        VStack(spacing: 0) {
            questionDeck
                .padding(.top, Spacing.lg)

            details
                .padding(.top, Spacing.lg)

            Spacer(minLength: Spacing.lg)

            AppButton(title: "Bergantian") { }
                .padding(.bottom, Spacing.lg)
        }
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.bgCard)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Edit", systemImage: "pencil") {
                    draftTitle = title
                    isShowingTitleEditor = true
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Selesai", systemImage: "xmark") {
                    dismiss()
                }.tint(.white)
            }
        }
        .alert(
            "Edit Judul",
            isPresented: $isShowingTitleEditor
        ) {
            TextField("Judul sesi", text: $draftTitle)

            Button("Batal", role: .cancel) { }

            Button("Simpan") {
                saveTitle()
            }
        } message: {
            Text("Masukkan judul baru untuk sesi ini.")
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

    private func saveTitle() {
        let newTitle = draftTitle.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !newTitle.isEmpty else {
            return
        }

        title = newTitle
        onTitleChanged(newTitle)
    }
}

private struct HistorySession: Identifiable, Equatable {
    let id = UUID()
    var title: String
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
