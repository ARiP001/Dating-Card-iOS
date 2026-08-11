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
                return "Sesi lawan bicaramu"
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
    }

    private enum Step: Equatable {
        case preferences
        case hatedTopics
        case putDownPhone
    }

    @State private var turn: Turn = .user
    @State private var step: Step = .preferences
    @State private var alertTurn: Turn? = .user

    @State private var userSelectedTopicIDs: Set<Int> = []
    @State private var userHatedTopicIDs: Set<Int> = []
    @State private var partnerSelectedTopicIDs: Set<Int> = []
    @State private var partnerHatedTopicIDs: Set<Int> = []

    var onClose: () -> Void = { }
    var onCompleted: (
        _ userSelectedTopicIDs: Set<Int>,
        _ userHatedTopicIDs: Set<Int>,
        _ partnerSelectedTopicIDs: Set<Int>,
        _ partnerHatedTopicIDs: Set<Int>
    ) -> Void = { _, _, _, _ in }

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
                    message: alertTurn.alertMessage
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
    }

    @ViewBuilder
    private var currentPage: some View {
        switch step {
        case .preferences:
            TurnBasedPreferencesChooseView(
                selectedTopicIDs: currentSelectedTopicIDs,
                onClose: onClose,
                onContinue: showHatedTopics
            )

        case .hatedTopics:
            TurnBasedHatedChooseView(
                selectedTopicIDs: currentSelectedTopicIDs.wrappedValue,
                hatedTopicIDs: currentHatedTopicIDs,
                onBack: {
                    step = .preferences
                },
                onSubmit: finishCurrentTurn
            )

        case .putDownPhone:
            SessionInstructionView(
                message: "Letakkan HP di tempat yang\ndapat kalian berdua lihat bersama",
                buttonTitle: "Mulai"
            ) {
                onCompleted(
                    userSelectedTopicIDs,
                    userHatedTopicIDs,
                    partnerSelectedTopicIDs,
                    partnerHatedTopicIDs
                )
            }
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
        step = .hatedTopics
    }

    private func finishCurrentTurn() {
        switch turn {
        case .user:
            turn = .partner
            step = .preferences
            alertTurn = .partner

        case .partner:
            step = .putDownPhone
        }
    }
}

private struct TurnAlert: View {
    let title: String
    let message: String
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

            AppButton(title: "Oke", action: onConfirm)
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
