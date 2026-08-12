//
//  TurnBasedPreferencesView.swift
//  DatingCard
//

import SwiftUI

struct TurnBasedPreferencesView: View {
    private enum Turn: Equatable {
        case user
        case partner

        var alertTitle: String {
            switch self {
            case .user:
                return "Sesi kamu"
            case .partner:
                return "Sesi partnermu"
            }
        }

        var alertMessage: String {
            switch self {
            case .user:
                return "Giliran kamu memilih topik yang ingin kalian bahas"
            case .partner:
                return "Giliran lawan bicara kamu memilih topik yang ingin kalian bahas"
            }
        }

        var accentColor: Color {
            switch self {
            case .user:
                return .accentDustyMauve
            case .partner:
                return .brandPrimaryRosePink
            }
        }
    }

    private enum Step: Equatable {
        case preferences
        case wouldYouRather
    }

    @State private var turn: Turn = .user
    @State private var step: Step = .preferences
    @State private var alertTurn: Turn? = .user
    @State private var isShowingHatedTopics = false

    @State private var userSelectedTopicIDs: Set<Int> = []
    @State private var userHatedTopicIDs: Set<Int> = []
    @State private var partnerSelectedTopicIDs: Set<Int> = []
    @State private var partnerHatedTopicIDs: Set<Int> = []

    var body: some View {
        ZStack {
            currentPage
                .allowsHitTesting(alertTurn == nil)

            if let alertTurn {
                Color.textPrimary
                    .opacity(0.45)
                    .ignoresSafeArea()

                TurnAlert(
                    title: alertTurn.alertTitle,
                    message: alertTurn.alertMessage,
                    accentColor: alertTurn.accentColor
                ) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.alertTurn = nil
                    }
                }
                .padding(.horizontal, Spacing.xl)
                .transition(.scale(scale: 0.96).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: step)
        .animation(.easeInOut(duration: 0.2), value: alertTurn != nil)
        .navigationDestination(isPresented: $isShowingHatedTopics) {
            TurnBasedHatedChooseView(
                selectedTopicIDs: currentSelectedTopicIDs.wrappedValue,
                accentColor: turn.accentColor,
                hatedTopicIDs: currentHatedTopicIDs,
                onSubmit: finishCurrentTurn
            )
            .id(turn)
        }
    }

    @ViewBuilder
    private var currentPage: some View {
        switch step {
        case .preferences:
            TurnBasedPreferencesChooseView(
                selectedTopicIDs: currentSelectedTopicIDs,
                accentColor: turn.accentColor,
                onContinue: showHatedTopics
            )
            .id(turn)
            .navigationBarBackButtonHidden(turn == .partner)

        case .wouldYouRather:
            WouldYouRatherView(topicIDs: combinedTopicIDs)
        }
    }

    private var currentSelectedTopicIDs: Binding<Set<Int>> {
        switch turn {
        case .user:
            return $userSelectedTopicIDs
        case .partner:
            return $partnerSelectedTopicIDs
        }
    }

    private var currentHatedTopicIDs: Binding<Set<Int>> {
        switch turn {
        case .user:
            return $userHatedTopicIDs
        case .partner:
            return $partnerHatedTopicIDs
        }
    }

    private func showHatedTopics() {
        currentHatedTopicIDs.wrappedValue.subtract(
            currentSelectedTopicIDs.wrappedValue
        )
        isShowingHatedTopics = true
    }

    private func finishCurrentTurn() {
        switch turn {
        case .user:
            isShowingHatedTopics = false
            turn = .partner
            step = .preferences
            alertTurn = .partner

        case .partner:
            printCombinedPreferences()
            isShowingHatedTopics = false
            step = .wouldYouRather
        }
    }

    private func printCombinedPreferences() {
        let availableTopics = Topics.all
            .filter { combinedTopicIDs.contains($0.id) }
            .map { "\($0.id): \($0.name)" }

        let output = availableTopics.isEmpty
            ? "Tidak ada topik yang tersedia"
            : availableTopics.joined(separator: ", ")

        print("TurnBased combined preferences: [\(output)]")
    }

    private var combinedTopicIDs: [Int] {
        let selectedIDs = userSelectedTopicIDs
            .union(partnerSelectedTopicIDs)
        let hatedIDs = userHatedTopicIDs
            .union(partnerHatedTopicIDs)
        let availableIDs = selectedIDs.subtracting(hatedIDs)

        return Topics.all.compactMap { topic in
            availableIDs.contains(topic.id) ? topic.id : nil
        }
    }
}

private struct TurnAlert: View {
    let title: String
    let message: String
    let accentColor: Color
    let onConfirm: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(title)
                    .font(AppFont.bodyBold)
                    .foregroundStyle(Color.textPrimary)

                Text(message)
                    .font(AppFont.bodyRegular)
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            AppButton(
                title: "Oke",
                accentColor: accentColor,
                action: onConfirm
            )
        }
        .padding(Spacing.lg)
        .frame(maxWidth: 330)
        .background(Color.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
    }
}

#Preview {
    TurnBasedPreferencesView()
}
