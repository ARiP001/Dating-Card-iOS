//
//  ContentView.swift
//  SelectPreferencesClip
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI

struct AppClipContentView: View {

    @EnvironmentObject private var router:
        AppClipInvocationRouter

    @State private var path:
        [AppClipDestination] = []

    @State private var selectedTopicIDs:
        Set<Int> = []

    @State private var hatedTopicIDs:
        Set<Int> = []

    @State private var isSubmitting = false

    @State private var submissionError:
        String?

    private let sessionService =
        SessionService()

    var body: some View {
        NavigationStack(path: $path) {

            SelectedTopicsView(
                selectedTopicIDs: $selectedTopicIDs
            ) {
                path.append(.hatedTopics)
            }

            .navigationDestination(
                for: AppClipDestination.self
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
        .alert(
            "Submission Failed",
            isPresented: errorBinding
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

    // MARK: - Submit

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
                    sessionID: sessionID,

                    selectedTopics:
                        selectedTopicIDs
                            .sorted(),

                    hatedTopics:
                        hatedTopicIDs
                            .sorted()
                )

            path.append(.success)

        } catch {

            submissionError =
                error.localizedDescription
        }
    }

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

// MARK: - Navigation Destination

private enum AppClipDestination:
    Hashable {

    case hatedTopics
    case success
}
