//
//  QRView.swift
//  DatingCard
//
import SwiftUI

struct QRView: View {
    @Environment(\.dismiss) private var dismiss

    private enum FlowStep: Equatable {
        case preferences
        case waitingForPartner
        case preferencesReceived
        case wouldYouRather
    }

    @StateObject private var viewModel = FullAppViewModel()

    @State private var selectedTopicIDs: Set<Int> = []
    @State private var hatedTopicIDs: Set<Int> = []

    @State private var flowStep: FlowStep = .preferences
    @State private var isShowingHatedTopics = false
    @State private var isShowingBackConfirmation = false

    @State private var hasPrintedCombinedPreferences = false

    var body: some View {
        Group {
            if flowStep == .wouldYouRather {
                completedContent
                    .transition(.opacity)

            } else if flowStep == .preferencesReceived {
                PreferencesReceivedView(
                    onAnimationCompleted: showWouldYouRather
                )
                .transition(.opacity)

            } else if partnerHasJoined {
                preferencesContent
                    .transition(.opacity)

            } else {
                qrContent
                    .transition(.opacity)
            }
        }
        .animation(
            .easeInOut(duration: 0.25),
            value: partnerHasJoined
        )
        .animation(
            .easeInOut(duration: 0.25),
            value: flowStep
        )
        .background(
            Color.bgPrimary
                .ignoresSafeArea()
        )

        // Leaving the root QR flow requires confirmation. Child pages such
        // as hated-topic selection keep their own native back navigation.
        .navigationBarBackButtonHidden(true)

        .toolbar {
            if partnerHasJoined && !isShowingHatedTopics {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingBackConfirmation = true
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .accessibilityLabel("Kembali")
                }
            }
        }

        .alert(
            "Kembali ke Home?",
            isPresented: $isShowingBackConfirmation
        ) {
            Button("Batal", role: .cancel) { }

            Button("Kembali", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Apakah yakin mau kembali ke Home?")
        }

        .task {
            if viewModel.sessionID == nil {
                await viewModel.createNewSession()
            }
        }

        .onChange(of: viewModel.state) {
            showReceiveAnimationIfReady()
            printCombinedPreferencesIfNeeded()
        }

        .onChange(of: flowStep) {
            printCombinedPreferencesIfNeeded()
        }

        .navigationDestination(
            isPresented: $isShowingHatedTopics
        ) {
            QRHatedChooseView(
                selectedTopicIDs: selectedTopicIDs,
                hatedTopicIDs: $hatedTopicIDs,
                onSubmit: showWaitingState
            )
        }
    }

    // MARK: - State

    private var partnerHasJoined: Bool {
        switch viewModel.state {
        case .joined, .completed:
            return true

        default:
            return false
        }
    }

    private var hostHasCompletedPreferences: Bool {
        switch flowStep {
        case .waitingForPartner, .preferencesReceived, .wouldYouRather:
            return true
        case .preferences:
            return false
        }
    }

    // MARK: - Preferences

    @ViewBuilder
    private var preferencesContent: some View {
        switch flowStep {
        case .preferences:
            QRPreferencesChooseView(
                selectedTopicIDs: $selectedTopicIDs,
                onContinue: {
                    hatedTopicIDs.subtract(
                        selectedTopicIDs
                    )

                    isShowingHatedTopics = true
                }
            )

        case .waitingForPartner:
            SessionWaitingView(
                message:
                    "Menunggu\nperangkat lain\nmenyelesaikan\npilihannya..."
            )

        case .preferencesReceived, .wouldYouRather:
            EmptyView()
        }
    }

    // MARK: - Completed

    @ViewBuilder
    private var completedContent: some View {
        WouldYouRatherView(
            topicIDs: combinedTopicIDs
        )
    }

    // MARK: - QR Page

    private var qrContent: some View {
        ZStack(alignment: .topTrailing) {
            Color.bgPrimary
                .ignoresSafeArea()

            closeButton

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 130)

                qrHeader

                Spacer()
                    .frame(height: 36)

                stateContent

                Spacer()
            }
            .padding(.horizontal, Spacing.xl)
        }
    }

    // MARK: - Close Button

    private var closeButton: some View {
        Button {
            isShowingBackConfirmation = true
        } label: {
            Image(systemName: "xmark")
                .font(
                    .title3.weight(.medium)
                )
                .foregroundStyle(
                    Color.textPrimary
                )
                .frame(
                    width: 44,
                    height: 44
                )
                .background(
                    .ultraThinMaterial
                )
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .padding(.trailing, Spacing.lg)
        .padding(.top, Spacing.md)
        .accessibilityLabel("Tutup")
    }

    // MARK: - Header

    private var qrHeader: some View {
        VStack(spacing: Spacing.sm) {
            Text(
                "Pindai Kode QR\nuntuk Bermain Bersama"
            )
            .font(AppFont.title2Bold)
            .foregroundStyle(
                Color.textPrimary
            )
            .multilineTextAlignment(.center)

            Text(
                "Anda bisa pindai kode QR ini melalui kamera handphone kalian untuk memulai permainan"
            )
            .font(AppFont.bodyRegular)
            .foregroundStyle(
                Color.textSecondary
            )
            .multilineTextAlignment(.center)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
            .frame(maxWidth: 310)
        }
        .frame(
            maxWidth: .infinity
        )
    }

    // MARK: - State Content

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.state {
        case .idle, .creating:
            AppLoadingView(
                message: "Menyiapkan sesi..."
            )
            .frame(height: 320)

        case .waiting:
            qrCode

        case let .failed(message):
            VStack(
                spacing: Spacing.md
            ) {
                Text(message)
                    .font(
                        AppFont.bodyRegular
                    )
                    .foregroundStyle(
                        Color.textSecondary
                    )
                    .multilineTextAlignment(
                        .center
                    )

                AppButton(
                    title: "Coba Lagi"
                ) {
                    Task {
                        await viewModel
                            .createNewSession()
                    }
                }
            }
            .frame(maxWidth: 320)

        case .joined, .completed:
            EmptyView()
        }
    }

    // MARK: - QR Code

    @ViewBuilder
    private var qrCode: some View {
        if let qrImage = viewModel.qrImage {
            ZStack {
                RoundedRectangle(
                    cornerRadius: 34
                )
                .fill(Color.bgCard)

                RoundedRectangle(
                    cornerRadius: 34
                )
                .stroke(
                    Color.textPrimary,
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round,
                        dash: [6, 6]
                    )
                )

                Image(
                    uiImage: qrImage
                )
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .padding(26)
            }
            .frame(
                width: 318,
                height: 318
            )
            .accessibilityLabel(
                "Kode QR untuk bergabung ke sesi"
            )
        }
    }

    // MARK: - Flow

    private func showWaitingState() {
        isShowingHatedTopics = false
        flowStep = .waitingForPartner
        showReceiveAnimationIfReady()
    }

    private func showReceiveAnimationIfReady() {
        guard
            viewModel.state == .completed,
            flowStep == .waitingForPartner
        else {
            return
        }

        flowStep = .preferencesReceived
    }

    private func showWouldYouRather() {
        guard flowStep == .preferencesReceived else {
            return
        }

        withAnimation(.easeInOut(duration: 0.25)) {
            flowStep = .wouldYouRather
        }
    }

    // MARK: - Combined Preferences

    private func printCombinedPreferencesIfNeeded() {
        guard
            viewModel.state == .completed,
            hostHasCompletedPreferences,
            !hasPrintedCombinedPreferences
        else {
            return
        }

        hasPrintedCombinedPreferences = true

        let availableTopics = Topics.all
            .filter {
                combinedTopicIDs.contains(
                    $0.id
                )
            }
            .map {
                "\($0.id): \($0.name)"
            }

        let output =
            availableTopics.isEmpty
            ? "Tidak ada topik yang tersedia"
            : availableTopics.joined(
                separator: ", "
            )

        print(
            "AppClip combined preferences: [\(output)]"
        )
    }

    private var combinedTopicIDs: [Int] {
        let partnerSelectedTopicIDs = Set(
            viewModel
                .receivedSelectedTopicIDs
        )

        let partnerHatedTopicIDs = Set(
            viewModel
                .receivedHatedTopicIDs
        )

        let selectedIDs =
            selectedTopicIDs
                .union(
                    partnerSelectedTopicIDs
                )

        let hatedIDs =
            hatedTopicIDs
                .union(
                    partnerHatedTopicIDs
                )

        let availableIDs =
            selectedIDs.subtracting(
                hatedIDs
            )

        return Topics.all.compactMap {
            topic in

            availableIDs.contains(topic.id)
            ? topic.id
            : nil
        }
    }
}

//#Preview {
//    QRView()
//}
