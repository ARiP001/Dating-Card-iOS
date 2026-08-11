//
//  ContentView.swift
//  SelectPreferencesClip
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct AppClipContentView: View {

    @EnvironmentObject
    private var router:
        AppClipInvocationRouter

    // MARK: - Navigation

    @State private var path:
        [AppClipDestination] = []

    // MARK: - Preferences

    @State private var selectedTopicIDs:
        Set<Int> = []

    @State private var hatedTopicIDs:
        Set<Int> = []

    // MARK: - Networking

    @State private var isSubmitting =
        false

    @State private var submissionError:
        String?

    @State private var hasMarkedAsJoined =
        false

    private let sessionService =
        SessionService()

    // MARK: - Body

    var body: some View {
        NavigationStack(
            path: $path
        ) {

            SelectedTopicsView(
                selectedTopicIDs:
                    $selectedTopicIDs
            ) {
                path.append(
                    .hatedTopics
                )
            }

            .navigationDestination(
                for:
                    AppClipDestination.self
            ) { destination in

                switch destination {

                case .hatedTopics:

                    HatedTopicsView(
                        selectedTopicIDs:
                            $selectedTopicIDs,

                        hatedTopicIDs:
                            $hatedTopicIDs,

                        isSubmitting:
                            isSubmitting
                    ) {
                        Task {
                            await submitPreferences()
                        }
                    }

                case .success:

                    PreferencesSentView()
                }
            }
        }

        // Akan dijalankan lagi ketika
        // sessionID berubah dari nil → actual ID.
        .task(
            id:
                router.invocation?
                    .sessionID
        ) {
            guard let sessionID =
                    router.invocation?
                        .sessionID
            else {
                return
            }

            await markAsJoinedIfNeeded(
                sessionID:
                    sessionID
            )
        }

        .alert(
            "Submission Failed",
            isPresented:
                errorBinding
        ) {

            Button(
                "OK",
                role: .cancel
            ) {
                submissionError = nil
            }

        } message: {

            Text(
                submissionError ??
                "Unknown error"
            )
        }
    }

    // MARK: - Mark Joined

    @MainActor
    private func markAsJoinedIfNeeded(
        sessionID: String
    ) async {

        guard !hasMarkedAsJoined else {
            return
        }

        guard !sessionID.isEmpty,
              sessionID !=
                "Session tidak ditemukan"
        else {
            return
        }

        do {
            try await sessionService
                .markSessionAsJoined(
                    sessionID:
                        sessionID
                )

            hasMarkedAsJoined = true

            print(
                "APP CLIP JOINED SESSION:",
                sessionID
            )

        } catch {
            print(
                "Failed marking session as joined:",
                error.localizedDescription
            )
        }
    }

    // MARK: - Submit Preferences

    @MainActor
    private func submitPreferences() async {

        guard let invocation =
                router.invocation
        else {
            submissionError =
                "Invocation URL belum diterima."

            return
        }

        let sessionID =
            invocation.sessionID

        guard !sessionID.isEmpty,
              sessionID !=
                "Session tidak ditemukan"
        else {
            submissionError =
                "Session ID tidak ditemukan."

            return
        }

        isSubmitting = true

        submissionError = nil

        defer {
            isSubmitting = false
        }

        do {
            try await sessionService
                .submitPreferences(
                    sessionID:
                        sessionID,

                    selectedTopics:
                        selectedTopicIDs
                            .sorted(),

                    hatedTopics:
                        hatedTopicIDs
                            .sorted()
                )

            path.append(
                .success
            )

        } catch {
            submissionError =
                error.localizedDescription
        }
    }

    // MARK: - Alert Binding

    private var errorBinding:
        Binding<Bool> {

        Binding(
            get: {
                submissionError != nil
            },

            set: { isPresented in

                if !isPresented {
                    submissionError = nil
                }
            }
        )
    }
}

// MARK: - Destination

private enum AppClipDestination:
    Hashable {

    case hatedTopics
    case success
}
