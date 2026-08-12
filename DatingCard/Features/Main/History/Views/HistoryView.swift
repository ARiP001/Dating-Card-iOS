import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<SessionModel> { session in
            session.isContinue == true
        },
        sort: \SessionModel.createdAt,
        order: .reverse
    ) private var sessions: [SessionModel]
    @State private var selectedSession: SessionModel?
    @State private var pendingSessionToResume: SessionModel?
    @State private var sessionToResume: SessionModel?
    @State private var isResumingSession = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Riwayat Permainan")
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
                            lastTopic: topicName(for: session.lastTopicID),
                            date: formattedDate(session.createdAt)
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
            .navigationDestination(isPresented: $isResumingSession) {
                if let sessionToResume {
                    WouldYouRatherView(session: sessionToResume)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .sheet(
            item: $selectedSession,
            onDismiss: presentPendingSession
        ) { session in
            NavigationStack {
                HistorySessionDetailView(
                    session: session,
                    onTitleChanged: { newTitle in
                        updateTitle(
                            newTitle,
                            for: session.id
                        )
                    },
                    onResume: {
                        pendingSessionToResume = session
                        selectedSession = nil
                    }
                )
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(Radius.xl)
            .presentationBackground(Color.bgCard)
        }
    }

    private func presentPendingSession() {
        guard let pendingSessionToResume else {
            return
        }

        self.pendingSessionToResume = nil
        sessionToResume = pendingSessionToResume
        isResumingSession = true
    }

    private func topicName(for topicID: Int?) -> String {
        guard let topicID else {
            return "Belum ada topik"
        }

        return Topics.all.first { $0.id == topicID }?.name
            ?? "Belum ada topik"
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter.string(from: date)
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
    let onResume: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var draftTitle: String
    @State private var isShowingTitleEditor = false

    init(
        session: SessionModel,
        onTitleChanged: @escaping (String) -> Void,
        onResume: @escaping () -> Void
    ) {
        self.session = session
        self.onTitleChanged = onTitleChanged
        self.onResume = onResume
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
                    onResume()
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
    }

    private var questionDeck: some View {
        Group {
            if session.pickedCards.isEmpty {
                VStack(spacing: Spacing.md) {
                    Image("kartuHabis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.xl)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: Spacing.md) {
                        ForEach(session.pickedCards, id: \.id) { card in
                            QuestionCard(question: card.question, topicID: card.topicID)
                        }
                    }
                }
            }
        }
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Divider()
            HStack {
                Text(session.pickedCards.isEmpty ? "Belum ada kartu yang sudah dibahas pada sesi ini." : "Sudah terpilih dan dibicarakan : ")
                    .font(AppFont.bodyRegular)
                Spacer()
                if !session.pickedCards.isEmpty {
                    Text("\(session.pickedCards.count) Kartu")
                        .font(AppFont.bodyBold)
                }
            }
            Divider()
            Text(session.isContinue ? "Kamu masih memiliki topik untuk dibicarakan dari sesi ini. Kamu bisa melanjutkan sesi ini." : "Semua topik di sesi ini sudah selesai dimainkan.")
                .font(AppFont.bodyRegular).foregroundStyle(Color.textPrimary)
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
