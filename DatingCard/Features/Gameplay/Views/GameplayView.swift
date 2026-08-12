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
    @AppStorage("requestedMainTab") private var requestedMainTab = "home"
    let onOpenAnotherPack: () -> Void

    init(session: SessionModel, topicID: Int, onOpenAnotherPack: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: GameplayViewModel(session: session, topicID: topicID))
        self.onOpenAnotherPack = onOpenAnotherPack
    }

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()
            switch viewModel.state {
            case .loading: ProgressView()
            case .playing: playingContent
            case .packFinished: endState(title: "Sedikit demi sedikit,\nkalian mulai saling mengenal", message: "Masih ada topik obrolan lain yang menunggu untuk kalian temukan. Yuk, lanjutkan obrolan kalian.", button: "Buka topik selanjutnya", action: onOpenAnotherPack)
            case .sessionFinished: endState(title: "Topik pilihan kalian\nsudah habis dimainkan", message: "Kalau masih ingin mengenalnya lebih jauh, yuk mulai lagi dan temukan sisi lain dari satu sama lain.", button: "Halaman utama", action: { requestedMainTab = "history"; dismiss() })
            case .loadFailed: loadFailedContent
            }
        }
        .task { viewModel.prepare(in: modelContext) }
        .overlay {
            if showsExitConfirmation {
                SessionExitConfirmation(
                    onContinue: { showsExitConfirmation = false },
                    onExit: { viewModel.keepSessionAvailable(in: modelContext); dismiss() }
                )
            }
        }
    }

    private var playingContent: some View {
        VStack(spacing: Spacing.lg) {
            ZStack {
                Text(viewModel.topicName).font(AppFont.title3Bold).foregroundStyle(Color.textPrimaryBlack)
                HStack {
                    Spacer()
                    Button { showsExitConfirmation = true } label: { Image(systemName: "xmark").font(.title3.weight(.medium)).foregroundStyle(Color.textPrimary).frame(width: 44, height: 44).background(Color.bgCard).clipShape(Circle()) }.buttonStyle(.plain)
                }
            }
            ZStack {
                ForEach(Array(viewModel.cards.enumerated().filter { $0.offset >= viewModel.currentIndex }.reversed()), id: \.element.id) { index, card in
                    GameplaySwipeCard(card: card, swipeRequest: index == viewModel.currentIndex ? swipeRequest : nil) { direction in
                        viewModel.recordSwipe(direction, in: modelContext)
                        swipeRequest = nil
                    }
                    .offset(y: CGFloat(index - viewModel.currentIndex) * 10)
                    .scaleEffect(1 - CGFloat(index - viewModel.currentIndex) * 0.03)
                    .allowsHitTesting(index == viewModel.currentIndex)
                }
            }.frame(maxHeight: .infinity)
        }.padding(.horizontal, Spacing.xl).padding(.vertical, Spacing.md)
    }

    // Fallback murni untuk error teknis (mis. fetch SwiftData gagal).
    // Kasus "kartu topik habis" sudah ditangani lebih awal di
    // WouldYouRatherView (.topicExhausted), jadi GameplayView seharusnya
    // tidak pernah dibuka lagi untuk topik yang kartunya sudah habis.
    private var loadFailedContent: some View {
        VStack(spacing: Spacing.md) {
            Text("Gagal memuat kartu").font(AppFont.title3Bold)
            Text("Terjadi kendala saat memuat pertanyaan untuk topik ini. Coba lagi sebentar lagi.").font(AppFont.bodyRegular).foregroundStyle(Color.textSecondary).multilineTextAlignment(.center)
            AppButton(title: "Kembali") { dismiss() }
        }.padding(Spacing.xl)
    }

    private func endState(title: String, message: String, button: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: Spacing.xl) {
            Spacer(); Text(title).font(AppFont.largeTitleBold).multilineTextAlignment(.center)
            Text(message).font(AppFont.bodyRegular).foregroundStyle(Color.textSecondary).multilineTextAlignment(.center)
            CardStackIllustration().frame(height: 280); Spacer()
            AppButton(title: button, action: action)
        }.padding(Spacing.xl)
    }

}

private struct GameplaySwipeCard: View {
    let card: CardModel
    let swipeRequest: SwipeRequest?
    let onSwipe: (SwipeDirection) -> Void
    @State private var offset: CGSize = .zero
    private let threshold: CGFloat = 120
    var body: some View {
        QuestionCard(question: card.question, topicID: card.topicID, width: 320, height: 475)
            .overlay { feedbackIcon }.offset(offset).rotationEffect(.degrees(offset.width / 18))
            .gesture(DragGesture().onChanged { offset = $0.translation }.onEnded { endDrag($0.translation) })
            .onChange(of: swipeRequest) { _, request in if let request { swipe(request.direction) } }
    }
    @ViewBuilder private var feedbackIcon: some View {
        if abs(offset.width) > 20 { Image(systemName: offset.width > 0 ? "checkmark" : "xmark").font(.title.bold()).foregroundStyle(.white).frame(width: 52, height: 52).background(offset.width > 0 ? Color.accentPrimary : Color.red).clipShape(Circle()).opacity(min(abs(offset.width) / threshold, 1)) }
    }
    private func endDrag(_ translation: CGSize) {
        if translation.width > threshold { swipe(.right) } else if translation.width < -threshold { swipe(.left) } else { withAnimation(.spring(response: 0.32, dampingFraction: 0.8)) { offset = .zero } }
    }
    private func swipe(_ direction: SwipeDirection) {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) { offset = CGSize(width: direction == .right ? 900 : -900, height: 80) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) { onSwipe(direction) }
    }
}
