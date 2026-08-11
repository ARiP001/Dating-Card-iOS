//
//  PreferenceChoose.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct PreferenceChooseContentView: View {
    @StateObject private var viewModel =
        FullAppViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header

                    content
                }
                .padding()
            }
            .navigationTitle(
                "Conversation Session"
            )
            .navigationBarTitleDisplayMode(
                .inline
            )
            .task {
                if viewModel.sessionID == nil {
                    await viewModel
                        .createNewSession()
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 10) {
            Image(
                systemName:
                    "person.2.fill"
            )
            .font(
                .system(size: 48)
            )
            .foregroundStyle(.blue)

            Text(
                "Start a Conversation"
            )
            .font(.title2.bold())

            Text(
                "Ask your partner to scan the QR code."
            )
            .multilineTextAlignment(
                .center
            )
            .foregroundStyle(
                .secondary
            )
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {

        case .idle,
             .creating:

            loadingView

        case .waiting:

            waitingView

        case .joined:

            joinedView

        case .completed:

            completedView

        case let .failed(message):

            errorView(
                message: message
            )
        }
    }

    // MARK: - Creating

    private var loadingView: some View {
        VStack(spacing: 14) {
            ProgressView()

            Text(
                "Creating session..."
            )
            .foregroundStyle(
                .secondary
            )
        }
        .padding(.vertical, 40)
    }

    // MARK: - Waiting

    private var waitingView: some View {
        VStack(spacing: 22) {
            qrCard

            HStack(spacing: 10) {
                ProgressView()

                VStack(
                    alignment: .leading,
                    spacing: 2
                ) {
                    Text(
                        "Waiting for partner"
                    )
                    .font(
                        .subheadline
                            .weight(.semibold)
                    )

                    Text(
                        "Belum ada yang membuka App Clip."
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()
            }
            .padding()
            .background(
                Color.secondary.opacity(
                    0.08
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
            )

            newSessionButton
        }
    }

    // MARK: - Joined

    private var joinedView: some View {
        VStack(spacing: 24) {

            Image(
                systemName:
                    "person.crop.circle.badge.checkmark"
            )
            .font(
                .system(size: 68)
            )
            .foregroundStyle(.green)

            VStack(spacing: 8) {
                Text(
                    "Partner Connected"
                )
                .font(.title2.bold())

                Text(
                    "Pasanganmu sudah membuka App Clip."
                )
                .font(.subheadline)
                .foregroundStyle(
                    .secondary
                )
                .multilineTextAlignment(
                    .center
                )
            }

            HStack(spacing: 12) {
                ProgressView()

                VStack(
                    alignment: .leading,
                    spacing: 3
                ) {
                    Text(
                        "Choosing preferences"
                    )
                    .font(
                        .subheadline
                            .weight(.semibold)
                    )

                    Text(
                        "Tunggu sampai pasanganmu selesai memilih."
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )
                }

                Spacer()
            }
            .padding()
            .frame(
                maxWidth: .infinity
            )
            .background(
                Color.green.opacity(
                    0.08
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
            )

            if let sessionID =
                viewModel.sessionID {

                Text(
                    "Session \(sessionID)"
                )
                .font(
                    .caption.monospaced()
                )
                .foregroundStyle(
                    .secondary
                )
            }
        }
        .padding(.vertical, 24)
    }

    // MARK: - QR Card

    private var qrCard: some View {
        VStack(spacing: 16) {
            if let qrImage =
                viewModel.qrImage {

                Image(
                    uiImage: qrImage
                )
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(
                    width: 250,
                    height: 250
                )
                .padding(14)
                .background(.white)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )
            }

            if let sessionID =
                viewModel.sessionID {

                VStack(spacing: 5) {
                    Text(
                        "Session ID"
                    )
                    .font(.caption)
                    .foregroundStyle(
                        .secondary
                    )

                    Text(sessionID)
                        .font(
                            .title3
                                .bold()
                                .monospaced()
                        )
                }
            }

            if let url =
                viewModel.invocationURL {

                Text(
                    url.absoluteString
                )
                .font(
                    .caption.monospaced()
                )
                .foregroundStyle(
                    .secondary
                )
                .multilineTextAlignment(
                    .center
                )
                .textSelection(
                    .enabled
                )
            }
        }
        .padding()
        .frame(
            maxWidth: .infinity
        )
        .background(
            .thinMaterial
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
    }

    // MARK: - Completed

    private var completedView: some View {
        VStack(spacing: 24) {

            Image(
                systemName:
                    "checkmark.circle.fill"
            )
            .font(
                .system(size: 64)
            )
            .foregroundStyle(.green)

            VStack(spacing: 6) {
                Text(
                    "Preferences Received"
                )
                .font(.title2.bold())

                if let sessionID =
                    viewModel.sessionID {

                    Text(
                        "Session \(sessionID)"
                    )
                    .font(
                        .caption.monospaced()
                    )
                    .foregroundStyle(
                        .secondary
                    )
                }
            }

            selectedTopicsSection

            hatedTopicsSection

            Button {
                Task {
                    await viewModel
                        .createNewSession()
                }

            } label: {

                Label(
                    "Start New Session",
                    systemImage: "plus"
                )
                .frame(
                    maxWidth: .infinity
                )
            }
            .buttonStyle(
                .borderedProminent
            )
            .controlSize(.large)
        }
    }

    // MARK: - Selected Topics

    private var selectedTopicsSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text(
                "Topics they want to discuss"
            )
            .font(.headline)

            if viewModel
                .receivedSelectedTopics
                .isEmpty {

                Text(
                    "No selected topics"
                )
                .font(.subheadline)
                .foregroundStyle(
                    .secondary
                )

            } else {

                ForEach(
                    viewModel
                        .receivedSelectedTopics
                ) { topic in

                    HStack(spacing: 12) {

                        Image(
                            systemName:
                                topic.systemImage
                        )
                        .frame(width: 24)
                        .foregroundStyle(
                            .blue
                        )

                        Text(
                            topic.title
                        )
                        .font(
                            .body.weight(
                                .medium
                            )
                        )

                        Spacer()

                        Image(
                            systemName:
                                "checkmark.circle.fill"
                        )
                        .foregroundStyle(
                            .green
                        )
                    }
                    .padding()
                    .background(
                        Color.secondary
                            .opacity(0.08)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14,
                            style: .continuous
                        )
                    )
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }

    // MARK: - Hated Topics

    private var hatedTopicsSection:
        some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text(
                "Topics they prefer to avoid"
            )
            .font(.headline)

            if viewModel
                .receivedHatedTopics
                .isEmpty {

                Text(
                    "No avoided topics"
                )
                .font(.subheadline)
                .foregroundStyle(
                    .secondary
                )

            } else {

                ForEach(
                    viewModel
                        .receivedHatedTopics
                ) { topic in

                    HStack(spacing: 12) {

                        Image(
                            systemName:
                                topic.systemImage
                        )
                        .frame(width: 24)
                        .foregroundStyle(
                            .red
                        )

                        Text(
                            topic.title
                        )
                        .font(
                            .body.weight(
                                .medium
                            )
                        )

                        Spacer()

                        Image(
                            systemName:
                                "xmark.circle.fill"
                        )
                        .foregroundStyle(
                            .red
                        )
                    }
                    .padding()
                    .background(
                        Color.red.opacity(
                            0.08
                        )
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14,
                            style: .continuous
                        )
                    )
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }

    // MARK: - New Session

    private var newSessionButton:
        some View {

        Button {
            Task {
                await viewModel
                    .createNewSession()
            }

        } label: {

            Label(
                "Create New Session",
                systemImage:
                    "arrow.clockwise"
            )
        }
        .buttonStyle(.bordered)
    }

    // MARK: - Error

    private func errorView(
        message: String
    ) -> some View {

        VStack(spacing: 18) {
            Image(
                systemName:
                    "exclamationmark.triangle.fill"
            )
            .font(
                .system(size: 52)
            )
            .foregroundStyle(
                .orange
            )

            Text(
                "Something went wrong"
            )
            .font(.title3.bold())

            Text(message)
                .font(.subheadline)
                .foregroundStyle(
                    .secondary
                )
                .multilineTextAlignment(
                    .center
                )

            Button(
                "Try Again"
            ) {
                if viewModel.sessionID == nil {

                    Task {
                        await viewModel
                            .createNewSession()
                    }

                } else {

                    viewModel
                        .retryPolling()
                }
            }
            .buttonStyle(
                .borderedProminent
            )
        }
        .padding(
            .vertical,
            30
        )
    }
}

//#Preview {
//    FullAppContentView()
//}
