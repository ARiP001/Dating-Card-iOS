import SwiftData
import SwiftUI

struct HistoryView: View {
    @Query(sort: \SessionModel.createdAt, order: .reverse) private var sessions: [SessionModel]
    @State private var selectedSession: SessionModel?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.md) {
                Text("Kumpulan Ceritamu")
                    .font(AppFont.title2Bold)
                    .foregroundStyle(Color.textPrimary)
                    .padding(.bottom, Spacing.sm)

                if sessions.isEmpty {
                    ContentUnavailableView(
                        "Belum ada riwayat sesi",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Sesi yang sudah kamu mulai akan muncul di sini.")
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.top, Spacing.xxl)
                }

                ForEach(sessions, id: \.id) { session in
                    HistorySessionCard(
                        title: session.title,
                        date: "\(session.createdAt.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "id_ID")))) | \(session.isContinue ? "Belum Selesai" : "Selesai")",
                        isContinue: session.isContinue
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
            if session.isContinue {
                AppButton(title: "Lanjutkan sesi") { resumeSession = true }
                    .padding(.bottom, Spacing.lg)
            }
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
                ForEach(session.pickedCards, id: \.id) { card in
                    QuestionCard(question: card.question, topicID: card.topicID)
                }
                if session.pickedCards.isEmpty {
                    emptyCard
                }
            }
        }
    }

    private var emptyCard: some View {
        Text("Belum ada kartu yang dipilih")
            .font(AppFont.bodyRegular).foregroundStyle(Color.textSecondary)
            .frame(width: 300, height: 475).background(Color.surfaceSecondary)
            .clipShape(RoundedRectangle(cornerRadius: Radius.sm))
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Divider()
            HStack {
                Text("Cerita yang terbuka").font(AppFont.bodyRegular)
                Spacer()
                Text("\(session.pickedCards.count) Kartu").font(AppFont.bodyBold)
            }
            Divider()
            Text(session.isContinue ? "Kamu masih memiliki topik untuk dibicarakan dari sesi ini. Kamu bisa melanjutkan sesi ini." : "Semua topik di sesi ini sudah selesai dimainkan.")
                .font(AppFont.bodyRegular).foregroundStyle(Color.textSecondary)
            if isEditingTitle {
                DatePicker("Tanggal sesi", selection: $editedDate, displayedComponents: .date)
                    .font(AppFont.bodyRegular)
            }
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
