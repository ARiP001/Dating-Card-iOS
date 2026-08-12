//
//  GameplayView.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 12/08/26.
//

import SwiftUI
import SwiftData

struct GameplayView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @StateObject private var viewModel: GameplayViewModel
    @State private var swipeRequest: SwipeRequest?
    @State private var showsExitConfirmation = false
    @State private var packFinishedContent = EndStatePool.packFinished.randomElement()!
    @State private var sessionFinishedContent = EndStatePool.sessionFinished.randomElement()!
    @AppStorage("requestedMainTab")
    private var requestedMainTab = "home"

    let onOpenAnotherPack: () -> Void

    #if DEBUG
    private let isPreview: Bool
    #endif

    // MARK: - Production Initializer

    init(
        session: SessionModel,
        topicID: Int,
        onOpenAnotherPack: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: GameplayViewModel(
                session: session,
                topicID: topicID
            )
        )

        self.onOpenAnotherPack = onOpenAnotherPack

        #if DEBUG
        self.isPreview = false
        #endif
    }

    // MARK: - Preview Initializer

    #if DEBUG
    init(previewState: GameplayViewModel.State) {
        let session = SessionModel()

        _viewModel = StateObject(
            wrappedValue: GameplayViewModel(
                previewSession: session,
                topicID: Topics.all[0].id,
                previewState: previewState
            )
        )

        self.onOpenAnotherPack = {}
        self.isPreview = true
    }
    #endif

    var body: some View {
        ZStack {
            Color.bgPrimary
                .ignoresSafeArea()

            switch viewModel.state {
            case .loading:
                ProgressView()

            case .playing:
                playingContent

            case .packFinished:
                            endState(
                                title: packFinishedContent.title,
                                message: packFinishedContent.message,
                                imageName: packFinishedContent.imageName,
                                button: "Buka Topik Selanjutnya",
                                showsCloseButton: true,
                                onClose: { showsExitConfirmation = true },
                                action: onOpenAnotherPack
                            )
            case .sessionFinished:
                endState(
                    title: sessionFinishedContent.title,
                    message: sessionFinishedContent.message,
                    imageName: sessionFinishedContent.imageName,
                    button: "Halaman Utama",
                    action: {
                        requestedMainTab = "history"
                        dismiss()
                    }
                )

            case .loadFailed:
                loadFailedContent
            }
        }
        .task {
            #if DEBUG
            guard !isPreview else { return }
            #endif

            viewModel.prepare(in: modelContext)
        }
        .onChange(of: viewModel.state) { _, newState in
            switch newState {
            case .packFinished:
                packFinishedContent = EndStatePool.packFinished.randomElement()!
            case .sessionFinished:
                sessionFinishedContent = EndStatePool.sessionFinished.randomElement()!
            default:
                break
            }
        }
        .overlay {
            if showsExitConfirmation {
                SessionExitConfirmation(
                    onContinue: {
                        showsExitConfirmation = false
                    },
                    onExit: {
                        viewModel.keepSessionAvailable(
                            in: modelContext
                        )
                        dismiss()
                    }
                )
            }
        }
    }

    // MARK: - Playing Content
    private var playingContent: some View {
            VStack(spacing: Spacing.lg) {
                ZStack {
                    Text(viewModel.topicName)
                        .font(AppFont.title2Bold)
                        .foregroundStyle(Color.textPrimaryBlack)

                    HStack {
                        Spacer()

                        Button {
                            showsExitConfirmation = true
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title3.weight(.medium))
                                .foregroundStyle(Color.textPrimary)
                                .frame(width: 44, height: 44)
                                // Menggunakan native material untuk efek liquid/frosted glass
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                }

            ZStack {
                ForEach(
                    Array(
                        viewModel.cards.enumerated()
                            .filter { $0.offset >= viewModel.currentIndex }
                            .prefix(5)
                            .reversed()
                    ),
                    id: \.element.id
                ) { index, card in

                    let depth = index - viewModel.currentIndex

                    let rotationAngles: [Double] = [0, 3.5, -2.5, 4.0, -3.0]
                    let xOffsets: [CGFloat] = [0, 6, -5, 8, -6]
                    let yOffsets: [CGFloat] = [0, 8, 14, 20, 26]

                    let rotation = depth < 5 ? rotationAngles[depth] : 0
                    let xOffset = depth < 5 ? xOffsets[depth] : 0
                    let yOffset = depth < 5 ? yOffsets[depth] : 0

                    GameplaySwipeCard(
                        card: card,
                        swipeRequest:
                            index == viewModel.currentIndex
                            ? swipeRequest
                            : nil
                    ) { direction in
                        viewModel.recordSwipe(
                            direction,
                            in: modelContext
                        )

                        swipeRequest = nil
                    }
                    .offset(x: xOffset, y: yOffset)
                    .rotationEffect(
                        .degrees(rotation),
                        anchor: .center
                    )
                    .scaleEffect(
                        1.0 - (CGFloat(depth) * 0.015)
                    )
                    .brightness(
                        -Double(depth) * 0.04
                    )
                    .shadow(
                        color: .black.opacity(depth == 0 ? 0.05 : 0.15),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                    .allowsHitTesting(
                        index == viewModel.currentIndex
                    )
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, Spacing.xxl)

            swipeInstructions
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.sm)
    }

    // MARK: - Swipe Instructions
    private var swipeInstructions: some View {
        HStack {
            // Swipe kiri
            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: "arrow.left")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.buttonPrimaryRed)

                Text("Jika topik tidak didiskusikan")
                    .font(AppFont.bodyRegular)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Swipe kanan
            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: "arrow.right")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.green)

                Text("Jika topik telah didiskusikan")
                    .font(AppFont.bodyRegular)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    // MARK: - Load Failed
    private var loadFailedContent: some View {
        VStack(spacing: Spacing.md) {
            Text("Gagal memuat kartu")
                .font(AppFont.title1Bold)

            Text(
                "Terjadi kendala saat memuat pertanyaan untuk topik ini. Silahkan coba lagi"
            )
            .font(AppFont.title3Bold)
            .foregroundStyle(Color.textSecondary)
            .multilineTextAlignment(.center)

            AppButton(title: "Kembali") {
                dismiss()
            }
        }
        .padding(Spacing.xl)
    }

    // MARK: - End State
        private func endState(
            title: String,
            message: String,
            imageName: String,
            button: String,
            showsCloseButton: Bool = false,
            onClose: (() -> Void)? = nil,
            action: @escaping () -> Void
        ) -> some View {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: Spacing.xl) {
                    Spacer()
                    VStack(spacing: Spacing.md) {
                        Text(title)
                            .font(AppFont.title1Bold)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(message)
                            .font(AppFont.title3Bold)
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 280)

                    Spacer()

                    AppButton(
                        title: button,
                        action: action
                    )
                }
                .padding(Spacing.xl)
                
                if showsCloseButton {
                    Button {
                        onClose?()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(Color.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, Spacing.md)
                    .padding(.trailing, Spacing.xl)
                }
            }
        }
}

// MARK: - Gameplay Swipe Card
private struct GameplaySwipeCard: View {
    let card: CardModel
    let swipeRequest: SwipeRequest?
    let onSwipe: (SwipeDirection) -> Void

    @State private var offset: CGSize = .zero

    private let threshold: CGFloat = 120

    var body: some View {
        QuestionCard(
            question: card.question,
            topicID: card.topicID,
            width: 320,
            height: 475
        )
        .overlay {
            feedbackIcon
        }
        .offset(offset)
        .rotationEffect(
            .degrees(offset.width / 18)
        )
        .gesture(
            DragGesture()
                .onChanged {
                    offset = $0.translation
                }
                .onEnded {
                    endDrag($0.translation)
                }
        )
        .onChange(of: swipeRequest) { _, request in
            if let request {
                swipe(request.direction)
            }
        }
    }

    @ViewBuilder
    private var feedbackIcon: some View {
        
            Image(
                systemName:
                    offset.width > 0
                    ? "checkmark"
                    : "xmark"
            )
            .font(.title.bold())
            .foregroundStyle(.white)
            .frame(width: 60, height: 60)
            .background(
                offset.width > 0
                    ? Color.green
                    : Color.red
            )
            .clipShape(Circle())
            .opacity(
                min(
                    abs(offset.width) / threshold,
                    1
                )
            )
            .offset(
                x: offset.width > 0 ? 120 : -120
                    )

        
    }

    private func endDrag(_ translation: CGSize) {
        if translation.width > threshold {
            swipe(.right)
        } else if translation.width < -threshold {
            swipe(.left)
        } else {
            withAnimation(
                .spring(
                    response: 0.32,
                    dampingFraction: 0.8
                )
            ) {
                offset = .zero
            }
        }
    }

    private func swipe(_ direction: SwipeDirection) {
        withAnimation(
            .spring(
                response: 0.32,
                dampingFraction: 0.82
            )
        ) {
            offset = CGSize(
                width: direction == .right
                    ? 900
                    : -900,
                height: 80
            )
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.26
        ) {
            onSwipe(direction)
        }
    }
}
// MARK: - End State Content
private struct EndStateContent {
    let title: String
    let message: String
    let imageName: String
}

private enum EndStatePool {
    static let packFinished: [EndStateContent] = [
        EndStateContent(
            title: "Secuil cerita tentangnya sudah kalian ketahui",
            message: "Yuk, kenali dia lebih jauh dengan mengeksplorasi topik pilihan kalian berikutnya.",
            imageName: "kartuHabis"
        ),
        EndStateContent(
            title: "Sedikit demi sedikit, kalian mulai saling kenal",
            message: "Masih ada topik obrolan lain yang menunggu untuk kalian temukan. Yuk, lanjutkan obrolan kalian.",
            imageName: "kartuHabis"
        ),
        EndStateContent(
            title: "Satu topik sudah kalian ceritakan bersama",
            message: "Masih ada topik lain yang belum dibuka. Yuk, buka kartu-kartu menarik selanjutnya.",
            imageName: "kartuHabis"
        )
    ]

    static let sessionFinished: [EndStateContent] = [
        EndStateContent(
            title: "Semua pack topik yang dipilih untuk sesi ini sudah dimainkan",
            message: "Tetapi masih banyak hal tentang satu sama lain yang bisa kalian temukan. Yuk, mulai lagi dan temukan lebih banyak tentang dirinya.",
            imageName: "packHabis"
        ),
        EndStateContent(
            title: "Topik pilihan kalian sudah habis, menandai berakhirnya sesi ini",
            message: "Kalau masih ingin mengenalnya lebih jauh, yuk main lagi dan temukan sisi lain dari satu sama lain.",
            imageName: "packHabis"
        ),
        EndStateContent(
                    title: "Sesi selesai, tapi momen manis kalian baru dimulai.",
                    message: "Masih penasaran satu sama lain? Kalian bisa mulai sesi baru kapan saja ya!",
                    imageName: "packHabis"
                )
    ]
}

// MARK: - Previews
#Preview("Gameplay - Full Flow") {
    let container = try! ModelContainer(
        for:
            CardModel.self,
            SessionModel.self,
        configurations:
            ModelConfiguration(
                isStoredInMemoryOnly: true
            )
    )

    let context = container.mainContext

    let session = SessionModel()
    let topicID = Topics.all[0].id

    context.insert(session)

    for index in 0..<5 {
        let card = CardModel(
            topicID: topicID,
            question: "Dummy question \(index + 1)"
        )

        context.insert(card)
    }

    return GameplayView(
        session: session,
        topicID: topicID,
        onOpenAnotherPack: {}
    )
    .modelContainer(container)
}

#if DEBUG

#Preview("Gameplay - Pack Finished") {
    GameplayView(
        previewState: .packFinished
    )
}

#Preview("Gameplay - Session Finished") {
    GameplayView(
        previewState: .sessionFinished
    )
}

#Preview("Gameplay - Load Failed") {
    GameplayView(
        previewState: .loadFailed
    )
}

#endif
