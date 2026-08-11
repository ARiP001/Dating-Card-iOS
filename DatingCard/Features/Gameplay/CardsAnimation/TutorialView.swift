import SwiftUI

struct TutorialView: View {
    let onStart: () -> Void

    @State private var step: TutorialStep = .swipeRight
    @State private var demoOffset: CGSize = .zero
    @State private var demoRotation: Double = 0
    @State private var isUserDragging = false
    @State private var loopTask: Task<Void, Never>?

    private let swipeThreshold: CGFloat = 110

    var body: some View {
        VStack(spacing: 20) {
            Text(step == .swipeRight ? "Try Answered" : "Try Skipped")
                .font(.title.bold())

            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let cardWidth = screenWidth
                let demoDistance = screenWidth * 0.42

                ZStack {
                    ZStack {
                        TutorialDemoCard()
                            .frame(width: cardWidth, height: 500)
                            .offset(demoOffset)
                            .rotationEffect(.degrees(demoRotation))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        loopTask?.cancel()
                                        isUserDragging = true
                                        demoOffset = value.translation
                                        demoRotation = Double(value.translation.width / 18)
                                    }
                                    .onEnded { value in
                                        handleTutorialSwipe(value.translation, demoDistance: demoDistance)
                                    }
                            )
                            .animation(.spring(response: 0.65, dampingFraction: 0.86), value: demoOffset)
                            .animation(.spring(response: 0.65, dampingFraction: 0.86), value: demoRotation)
                    }
                    .frame(width: screenWidth * 2.4, height: 560)
                    .position(x: screenWidth / 2, y: 280)
                    .zIndex(1)

                    HStack {
                        TutorialHint(
                            title: "Answered",
                            subtitle: "Swipe right",
                            symbol: "arrow.right",
                            color: .black,
                            opacity: step == .swipeRight ? 1 : 0
                        )

                        Spacer()

                        TutorialHint(
                            title: "Skipped",
                            subtitle: "Swipe left",
                            symbol: "arrow.left",
                            color: .black,
                            opacity: step == .swipeLeft ? 1 : 0
                        )
                    }
                    .padding(.horizontal, 18)
                    .frame(width: screenWidth)
                    .position(x: screenWidth / 2, y: 280)
                    .zIndex(2)
                }
                .onAppear {
                    startLoopingTutorialAnimation(distance: demoDistance)
                }
                .onChange(of: step) { _, _ in
                    startLoopingTutorialAnimation(distance: demoDistance)
                }
            }
            .frame(height: 560)

            Text(step == .swipeRight ? "Swipe the card right to mark it answered." : "Now swipe the card left to skip it.")
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer(minLength: 20)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .onDisappear {
            loopTask?.cancel()
        }
    }

    private func startLoopingTutorialAnimation(distance: CGFloat) {
        loopTask?.cancel()
        isUserDragging = false

        loopTask = Task {
            while !Task.isCancelled {
                await resetDemo()
                try? await Task.sleep(nanoseconds: 500_000_000)

                await animateDemo(directionForCurrentStep, distance: distance)
                try? await Task.sleep(nanoseconds: 900_000_000)

                await resetDemo()
                try? await Task.sleep(nanoseconds: 700_000_000)
            }
        }
    }

    private var directionForCurrentStep: SwipeDirection {
        step == .swipeRight ? .right : .left
    }

    @MainActor
    private func animateDemo(_ direction: SwipeDirection, distance: CGFloat) async {
        guard !isUserDragging else { return }

        withAnimation(.spring(response: 0.8, dampingFraction: 0.9)) {
            demoOffset = CGSize(width: direction == .right ? distance : -distance, height: 20)
            demoRotation = direction == .right ? 14 : -14
        }
    }

    @MainActor
    private func resetDemo() async {
        guard !isUserDragging else { return }

        withAnimation(.spring(response: 0.7, dampingFraction: 0.9)) {
            demoOffset = .zero
            demoRotation = 0
        }
    }

    private func handleTutorialSwipe(_ translation: CGSize, demoDistance: CGFloat) {
        isUserDragging = false

        let swipedRight = translation.width > swipeThreshold
        let swipedLeft = translation.width < -swipeThreshold

        if step == .swipeRight && swipedRight {
            completeCurrentTutorialSwipe(.right)
        } else if step == .swipeLeft && swipedLeft {
            completeCurrentTutorialSwipe(.left)
        } else {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                demoOffset = .zero
                demoRotation = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                startLoopingTutorialAnimation(distance: demoDistance)
            }
        }
    }

    private func completeCurrentTutorialSwipe(_ direction: SwipeDirection) {
        loopTask?.cancel()

        withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
            demoOffset = CGSize(width: direction == .right ? 900 : -900, height: 90)
            demoRotation = direction == .right ? 22 : -22
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            if step == .swipeRight {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                    step = .swipeLeft
                    demoOffset = .zero
                    demoRotation = 0
                }
            } else {
                onStart()
            }
        }
    }
}

struct TutorialDemoCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.blue)

            Text("This is a Conversation Card")
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(32)
        }
        .shadow(color: .black.opacity(0.18), radius: 16, x: 0, y: 10)
    }
}

struct TutorialHint: View {
    let title: String
    let subtitle: String
    let symbol: String
    let color: Color
    let opacity: Double

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.title2.bold())

            Text(title)
                .font(.headline.bold())

            Text(subtitle)
                .font(.caption)
        }
        .foregroundStyle(color)
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .opacity(opacity)
        .animation(.easeInOut(duration: 0.3), value: opacity)
    }
}
