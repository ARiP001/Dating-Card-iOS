import SwiftUI

struct TutorialView: View {
    let topicID: Int
    let onCompleted: () -> Void

    @State private var step: TutorialStep = .swipeRight
    @State private var cardOffset: CGSize = .zero
    @State private var cardRotation = 0.0
    @State private var isCompletingStep = false
    @State private var isUserDragging = false
    @State private var motionCueTask: Task<Void, Never>?

    private let swipeThreshold: CGFloat = 110

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.textPrimary.opacity(0.80)
                    .ignoresSafeArea()

                VStack(spacing: Spacing.lg) {
                    instructionHeader

                    ZStack {
                        tutorialCard(
                            topicID: topicID,
                            width: min(320, geometry.size.width - 64),
                            height: min(475, geometry.size.height * 0.58)
                        )
                        .offset(cardOffset)
                        .rotationEffect(.degrees(cardRotation))
                        .gesture(tutorialDrag)
                        .animation(
                            .spring(
                                response: 0.34,
                                dampingFraction: 0.82
                            ),
                            value: cardOffset
                        )
                        .animation(
                            .spring(
                                response: 0.34,
                                dampingFraction: 0.82
                            ),
                            value: cardRotation
                        )

                        edgeActionIndicators
                            .allowsHitTesting(false)
                    }
                    .frame(maxHeight: .infinity)
                    .offset(y: -20)

                    swipeDirectionCue

                    instructionCopy
                        .padding(.horizontal, Spacing.xl)
                }
                .padding(.top, Spacing.lg)
                .padding(.bottom, Spacing.xl)
            }
        }
        .accessibilityElement(children: .contain)
        .onAppear {
            startMotionCue()
        }
        .onChange(of: step) {
            startMotionCue()
        }
        .onDisappear {
            motionCueTask?.cancel()
        }
    }

    private var instructionHeader: some View {
        VStack(spacing: Spacing.xs) {
            Text(
                step == .swipeRight
                    ? "Coba geser ke kanan"
                    : "Sekarang geser ke kiri"
            )
            .font(AppFont.title2Bold)
            .foregroundStyle(Color.bgCard)

            Text(step == .swipeRight ? "Simpan" : "Lewati")
                .font(AppFont.headlineSemibold)
                .foregroundStyle(activeColor)
        }
    }

    private var swipeDirectionCue: some View {
        HStack(spacing: Spacing.sm) {
            if step == .swipeLeft {
                directionArrow(systemName: "arrow.left")
            }

            Image(
                systemName: "hand.point.up.left.fill"
            )
            .font(.system(size: 36, weight: .semibold))

            if step == .swipeRight {
                directionArrow(systemName: "arrow.right")
            }
        }
        .foregroundStyle(Color.bgCard)
        .symbolEffect(.pulse.byLayer, options: .repeating)
        .transition(.scale.combined(with: .opacity))
        .animation(.easeInOut(duration: 0.24), value: step)
        .offset(y: -12)
    }

    private func directionArrow(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 62, height: 24)
            .clipped()
    }

    private var edgeActionIndicators: some View {
        HStack {
            if step == .swipeLeft {
                actionIndicator(
                    systemName: "xmark",
                    color: .buttonPrimaryRed
                )
                .offset(x: -22)
                .transition(
                    .scale(scale: 0.7)
                    .combined(with: .opacity)
                )
            }

            Spacer()

            if step == .swipeRight {
                actionIndicator(
                    systemName: "checkmark",
                    color: .accentPrimary
                )
                .offset(x: 22)
                .transition(
                    .scale(scale: 0.7)
                    .combined(with: .opacity)
                )
            }
        }
        .padding(.horizontal, Spacing.sm)
        .animation(.easeInOut(duration: 0.24), value: step)
    }

    private func actionIndicator(
        systemName: String,
        color: Color
    ) -> some View {
        Image(systemName: systemName)
            .font(.title.bold())
            .foregroundStyle(Color.bgCard)
            .frame(width: 76, height: 76)
            .background(color)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color.bgCard, lineWidth: 2)
            }
    }

    private func tutorialCard(
        topicID: Int,
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        RoundedRectangle(
            cornerRadius: Radius.lg,
            style: .continuous
        )
        .fill(Color.topicColor(for: topicID))
        .frame(width: width, height: height)
        .overlay {
            Text("Kartu Pertanyaan")
                .font(AppFont.title1Bold)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .padding(Spacing.xl)
        }
        .shadow(
            color: Color.textPrimary.opacity(0.22),
            radius: 14,
            y: 8
        )
    }

    private var instructionCopy: some View {
        VStack(spacing: Spacing.xs) {
            Text(
                step == .swipeRight
                    ? "Swipe ke kanan kalau sudah selesai dibahas"
                    : "Swipe ke kiri kalau ingin melewati kartu"
            )
            .font(AppFont.headlineSemibold)
            .foregroundStyle(Color.bgCard)

            Text(
                step == .swipeRight
                    ? "Kartu ini dapat dilihat di riwayat dan tidak akan muncul lagi"
                    : "Kartu ini tidak akan disimpan dan tidak akan muncul lagi"
            )
            .font(AppFont.bodyRegular)
            .foregroundStyle(Color.bgCard.opacity(0.82))
        }
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var activeColor: Color {
        step == .swipeRight
            ? .accentDustyMauve
            : .buttonPrimaryRed
    }

    private var tutorialDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                guard !isCompletingStep else { return }
                motionCueTask?.cancel()
                isUserDragging = true
                cardOffset = value.translation
                cardRotation = Double(value.translation.width / 18)
            }
            .onEnded { value in
                finishDrag(value.translation)
            }
    }

    private func finishDrag(_ translation: CGSize) {
        guard !isCompletingStep else { return }
        isUserDragging = false

        let completedExpectedSwipe =
            (step == .swipeRight && translation.width > swipeThreshold)
            || (step == .swipeLeft && translation.width < -swipeThreshold)

        guard completedExpectedSwipe else {
            cardOffset = .zero
            cardRotation = 0

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                startMotionCue()
            }
            return
        }

        motionCueTask?.cancel()
        isCompletingStep = true

        withAnimation(.easeIn(duration: 0.28)) {
            cardOffset = CGSize(
                width: step == .swipeRight ? 700 : -700,
                height: 60
            )
            cardRotation = step == .swipeRight ? 20 : -20
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if step == .swipeRight {
                step = .swipeLeft
                cardOffset = .zero
                cardRotation = 0
                isCompletingStep = false
            } else {
                onCompleted()
            }
        }
    }

    private func startMotionCue() {
        motionCueTask?.cancel()
        isUserDragging = false

        let direction: CGFloat = step == .swipeRight ? 1 : -1

        motionCueTask = Task { @MainActor in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 650_000_000)
                guard !Task.isCancelled, !isUserDragging else { return }

                withAnimation(
                    .easeInOut(duration: 0.55)
                ) {
                    cardOffset = CGSize(
                        width: direction * 96,
                        height: 8
                    )
                    cardRotation = Double(direction * 8)
                }

                try? await Task.sleep(nanoseconds: 650_000_000)
                guard !Task.isCancelled, !isUserDragging else { return }

                withAnimation(
                    .spring(
                        response: 0.48,
                        dampingFraction: 0.82
                    )
                ) {
                    cardOffset = .zero
                    cardRotation = 0
                }

                try? await Task.sleep(nanoseconds: 700_000_000)
            }
        }
    }
}

#Preview {
    TutorialView(
        topicID: 1,
        onCompleted: { }
    )
}
