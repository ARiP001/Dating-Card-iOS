import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
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

        do {
            try modelContext.save()
        } catch {
            print("Failed to update session title: \(error)")
        }
    }
}

private struct HistorySessionDetailView: View {
    let session: SessionModel
    let onTitleChanged: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var draftTitle: String
    @State private var isShowingTitleEditor = false
    @State private var isResumingSession = false

    init(
        session: SessionModel,
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
                AppButton(title: "Lanjutkan sesi") {
                    isResumingSession = true
                }
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
        .navigationDestination(isPresented: $isResumingSession) {
            WouldYouRatherView(session: session)
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

#Preview {
    HistoryView()
}
