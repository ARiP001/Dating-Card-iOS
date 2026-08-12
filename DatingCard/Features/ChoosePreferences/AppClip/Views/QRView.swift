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
    }

    @StateObject private var viewModel = FullAppViewModel()

    @State private var selectedTopicIDs: Set<Int> = []
    @State private var hatedTopicIDs: Set<Int> = []

    @State private var flowStep: FlowStep = .preferences
    @State private var isShowingHatedTopics = false

    @State private var hasPrintedCombinedPreferences = false

    var body: some View {
        Group {
            if shouldShowCompletedContent {
                completedContent
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
            value: shouldShowCompletedContent
        )
        .background(
            Color.bgPrimary
                .ignoresSafeArea()
        )

        // Saat masih QR page,
        // gunakan X custom dan hide native back.
        .navigationBarBackButtonHidden(!partnerHasJoined)

        .task {
            if viewModel.sessionID == nil {
                await viewModel.createNewSession()
            }
        }

        .onChange(of: viewModel.state) {
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
        flowStep == .waitingForPartner
    }

    private var shouldShowCompletedContent: Bool {
        viewModel.state == .completed
        && hostHasCompletedPreferences
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
                    "Menunggu perangkat lain\nmenyelesaikan pilihannya"
            )
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
            dismiss()
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
                    Color.bgCard.opacity(0.85)
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
                "Mulai dengan memilih topik yang ingin kalian jelajahi bersama."
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
