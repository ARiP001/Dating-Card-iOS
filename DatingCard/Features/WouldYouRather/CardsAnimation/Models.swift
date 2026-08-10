import SwiftUI

struct ChoiceCard: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let symbol: String
    let color: Color
}

struct SwipeCard: Identifiable, Equatable {
    let id = UUID()
    let question: String
    let color: Color
}

enum AppFlow {
    case pickingCards
    case wouldYouRather
    case tutorial
    case cards
}

enum SwipeDirection {
    case left
    case right
}

enum PickingPhase {
    case combiningDecks
    case spinning
    case picked
}

enum TutorialStep {
    case swipeRight
    case swipeLeft
}

struct SwipeRequest: Equatable {
    let id = UUID()
    let direction: SwipeDirection
}

struct CardPlacement {
    let x: CGFloat
    let y: CGFloat
    let scale: CGFloat
    let opacity: Double
    let blur: CGFloat
    let flip: Double
    let tilt: Double
    let zIndex: Double
}
