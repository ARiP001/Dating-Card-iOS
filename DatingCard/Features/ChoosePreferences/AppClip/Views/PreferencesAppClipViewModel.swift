//
//  P.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import Foundation
import UIKit
import Combine

@MainActor
final class PreferencesAppClipViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case creating
        case waiting
        case completed
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var sessionID: String?
    @Published private(set) var invocationURL: URL?
    @Published private(set) var qrImage: UIImage?
    @Published private(set) var receivedTopics: [String] = []
    @Published private(set) var receivedSelectedTopicIDs: [Int] = []
    @Published private(set) var receivedHatedTopicIDs: [Int] = []
    
    var receivedSelectedTopics: [ConversationTopic] {
        receivedSelectedTopicIDs.compactMap {
            ConversationTopic.topic(for: $0)
        }
    }

    var receivedHatedTopics: [ConversationTopic] {
        receivedHatedTopicIDs.compactMap {
            ConversationTopic.topic(for: $0)
        }
    }
    
    private let service = SessionService()
    private var pollingTask: Task<Void, Never>?

    deinit {
        pollingTask?.cancel()
    }

    func createNewSession() async {
        pollingTask?.cancel()

        state = .creating
        receivedTopics = []

        let id = Self.makeSessionID()

        guard let url = URL(
            string: "https://easyconvo.com/join?session=\(id)"
        ) else {
            state = .failed("Gagal membuat invocation URL.")
            return
        }

        do {
            try await service.createSession(id: id)

            sessionID = id
            invocationURL = url
            qrImage = QRCodeGenerator.generate(
                from: url.absoluteString
            )

            state = .waiting
            startPolling(sessionID: id)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func retryPolling() {
        guard let sessionID else {
            return
        }

        state = .waiting
        startPolling(sessionID: sessionID)
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    private func startPolling(sessionID: String) {
        pollingTask?.cancel()

        pollingTask = Task { [weak self] in
            guard let self else { return }

            while !Task.isCancelled {
                do {
                    let session = try await service.fetchSession(
                        id: sessionID
                    )

                    if session.status == "completed" {
                        receivedSelectedTopicIDs =
                            session.selectedTopics

                        receivedHatedTopicIDs =
                            session.hatedTopics

                        state = .completed
                        pollingTask = nil

                        return
                    }
                } catch is CancellationError {
                    return
                } catch {
                    state = .failed(
                        error.localizedDescription
                    )

                    pollingTask = nil
                    return
                }

                do {
                    try await Task.sleep(
                        for: .seconds(2)
                    )
                } catch {
                    return
                }
            }
        }
    }

    private static func makeSessionID() -> String {
        String(
            UUID()
                .uuidString
                .replacingOccurrences(
                    of: "-",
                    with: ""
                )
                .prefix(8)
        )
        .uppercased()
    }
}
