//
//  CardShufflingView.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 11/08/26.
//

import SwiftUI

struct CardShufflingView: View {
    let topicIDs: [Int]
    var onContinue: (() -> Void)?
    @StateObject private var viewModel = CardShufflingViewModel()
    
    // State untuk mencegah klik tombol berkali-kali saat transisi
    @State private var isTransitioning = false

    init(topicIDs: [Int] = Topics.all.map(\.id).shuffled(), onContinue: (() -> Void)? = nil) {
        self.topicIDs = topicIDs
        self.onContinue = onContinue
    }

    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: .bgPrimary, location: 0.0),
                    .init(color: .bgPrimary, location: 0.35),
                    .init(color: .accentPrimary, location: 0.85)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ConcentricDashedCirclesView()

            VStack(alignment: .leading, spacing: 24) {
                Spacer()

                OneByOneShuffleView(
                    shuffleStep: viewModel.shuffleStep,
                    isReversing: viewModel.isReversing,
                    topicIDs: topicIDs
                )
                .frame(height: 260)

                Spacer()

                Text("Letakkan device ini di tempat yang dapat kalian berdua lihat bersama")
                    .font(AppFont.title1Bold)
                    .foregroundStyle(Color.textSecondaryWhite)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 4)

                Spacer()

                Button {
                    guard !isTransitioning else { return }
                    isTransitioning = true

                    Task {
                        viewModel.stopLoop()

                        withAnimation(
                            .spring(
                                response: 0.45,
                                dampingFraction: 0.85
                            )
                        ) {
                            viewModel.shuffleStep = 0
                        }

                        try? await Task.sleep(
                            nanoseconds: 450_000_000
                        )

                        onContinue?()
                    }
                } label: {
                    Text("Lanjut")
                        .font(.headline)
                        .foregroundStyle(Color.accentPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 28)
                        )
                        .shadow(
                            color: .black.opacity(0.1),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
            .padding(.top, 64)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.startLoop()
        }
        .onDisappear {
            viewModel.stopLoop()
        }
    }
}

#Preview {
    CardShufflingView()
}
