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
        .sheet(isPresented: Binding(
            get: { selectedSession != nil },
            set: { if !$0 { selectedSession = nil } }
        )) {
            if let selectedSession {
                HistorySessionDetailView(session: selectedSession)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(Radius.xl)
                    .presentationBackground(Color.bgCard)
            }
        }
    }
}

private struct HistorySessionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let session: SessionModel
    @State private var isEditingTitle = false
    @State private var editedTitle = ""
    @State private var editedDate = Date()
    @State private var resumeSession = false

    var body: some View {
        VStack(spacing: 0) {
            header.padding(.top, Spacing.md).padding(.bottom, Spacing.lg)
            questionDeck
            details.padding(.top, Spacing.lg)
            Spacer(minLength: Spacing.lg)
            if session.isContinue {
                AppButton(title: "Lanjutkan sesi") { resumeSession = true }
                    .padding(.bottom, Spacing.lg)
            }
        }
        .padding(.horizontal, Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.bgCard)
        .onAppear { editedTitle = session.title; editedDate = session.createdAt }
        .fullScreenCover(isPresented: $resumeSession) {
            WouldYouRatherView(session: session)
        }
    }

    private var header: some View {
        ZStack {
            if isEditingTitle {
                TextField("Nama sesi", text: $editedTitle, onCommit: saveTitle)
                    .font(AppFont.bodyBold).multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder).padding(.horizontal, 54)
            } else {
                Text(session.title).font(AppFont.bodyBold).lineLimit(1)
            }
            HStack {
                Button { isEditingTitle ? saveTitle() : (isEditingTitle = true) } label: {
                    Image(systemName: isEditingTitle ? "checkmark" : "pencil")
                        .foregroundStyle(Color.textPrimary).frame(width: 44, height: 44)
                        .background(Color.surfaceSecondary).clipShape(Circle())
                }.buttonStyle(.plain)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark").foregroundStyle(Color.textPrimary).frame(width: 44, height: 44)
                        .background(Color.surfaceSecondary).clipShape(Circle())
                }.buttonStyle(.plain)
            }
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
        let title = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        if !title.isEmpty { session.title = title }
        session.createdAt = editedDate
        try? modelContext.save()
        isEditingTitle = false
    }
}
