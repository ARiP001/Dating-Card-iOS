//
//  CardShufflingViewModel.swift
//  DatingCard
//
//  Created by Made Vidyatma Adhi Krisna on 11/08/26.
//

import Combine
import Foundation

@MainActor
final class CardShufflingViewModel: ObservableObject {
    @Published var shuffleStep = 0
    @Published var isReversing = false

    private var shuffleLoopTask: Task<Void, Never>?

    func startLoop(stepCount: Int) {
        shuffleLoopTask?.cancel()

        let finalStep = max(stepCount, 1)

        shuffleLoopTask = Task { [weak self] in
            var step = 0
            var direction = 1

            while !Task.isCancelled {
                guard let self else { return }

                self.isReversing = direction == -1
                self.shuffleStep = step

                let delay: UInt64 = step == finalStep || step == 0
                    ? 1_000_000_000
                    : 220_000_000

                try? await Task.sleep(nanoseconds: delay)

                step += direction

                if step >= finalStep {
                    step = finalStep
                    direction = -1
                } else if step <= 0 {
                    step = 0
                    direction = 1
                }
            }
        }
    }

    func stopLoop() {
        shuffleLoopTask?.cancel()
        shuffleLoopTask = nil
    }
}
