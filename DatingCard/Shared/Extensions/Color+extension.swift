//
//  Color+extension.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import SwiftUI
import Foundation

// MARK: - Hex Color Helper
extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64

        switch hex.count {
        case 3:
            (a, r, g, b) = (
                255,
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )

        case 6:
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )

        case 8:
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )

        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

        // MARK: - Color Palette
extension Color {
    
    // MARK: Arif
    static let bgPrimary = Color(hex: "#F2F2F7")
    static let bgCard = Color(hex: "#FFFFFF")
    static let surfaceSecondary = Color(hex: "#3B2C33")
    static let accentPrimary = Color(hex: "#A85FD4")
    static let textPrimary = Color(hex: "#000000")
    static let textSecondary = Color(hex: "#8E8E93")
    static let border = Color(hex: "#3B2C33").opacity(0.2)
    
    // MARK: Brand
    static let brandPrimaryRosePink = Color(hex: "#D45F96")
    
    // MARK: Button
    static let buttonPrimaryBlue = Color(hex: "#0088FF")
    static let buttonPrimaryRed = Color(hex: "#FF393C")
    
    // MARK: Accent
    static let accentDarkTaupe = Color(hex: "#D5785F")
    static let accentDustyMauve = Color(hex: "#A85FD4")
    
    // MARK: Neutral
    static let neutralDarkCharcoal = Color(hex: "#3B2C33")
    
    // MARK: Surface
    static let surfacePrimaryTerracotta = Color(hex: "#D4625F")
    static let surfacePrimaryOrchid = Color(hex: "#CF5FD5")
    
    // MARK: Text
    static let textPrimaryBlack = Color(hex: "#000000")
    static let textSecondaryDarkGrey = Color(hex: "#8E8E93")
    static let textSecondaryLightGrey = Color(hex: "#F2F2F7")
    static let textSecondaryWhite = Color(hex: "#FFFFFF")
}

// MARK: - Card Colors
extension Color {
    // MARK: Identity
    static let cardAboutMe = Color(hex: "#E89A3E")
    static let cardThingsILove = Color(hex: "#F0AC62")
    static let cardGrowingUp = Color(hex: "#F6BE85")
    static let cardFamilyLife = Color(hex: "#FBD0A7")
    static let cardMyPeople = Color(hex: "#FCDAB8")

    // MARK: Lifestyle
    static let cardDailyLife = Color(hex: "#C7DC72")
    static let cardSocialEnergy = Color(hex: "#D2E28C")
    static let cardMoneyNPriorities = Color(hex: "#DDE9A6")
    static let cardWorkNAmbition = Color(hex: "#E7EFBF")

    // MARK: Values
    static let cardWhatMattersToMe = Color(hex: "#AD7EFE")
    static let cardRightNWrong = Color(hex: "#BE95FF")
    static let cardMeaningFulLife = Color(hex: "#CEACFF")
    static let cardBeliefsNWorldview = Color(hex: "#DDC4FF")

    // MARK: Relationship
    static let cardFirstConnections = Color(hex: "#C94D75")
    static let cardHealtyRelationships = Color(hex: "#D6708C")
    static let cardCommunication = Color(hex: "#E290A5")
    static let cardQualityTime = Color(hex: "#ECB0BE")
    static let cardLoveInTheFuture = Color(hex: "#F0C0CA")

    // MARK: Emotional
    static let cardFeelings = Color(hex: "#6CAFD0")
    static let cardEmotionalSafety = Color(hex: "#89BDD9")
    static let cardStressNBadDays = Color(hex: "#A4CCE1")
    static let cardConflictNRepair = Color(hex: "#BFDAEA")
    static let cardHiddenSides = Color(hex: "#CCE1EE")
    
    // MARK: Future
    static let cardFutureMe = Color(hex: "#FF8CFF")
    static let cardDreamLife = Color(hex: "#FFC3FF")

    static func topicColor(for topicID: Int) -> Color {
        switch topicID {
        case 1:
            return .cardAboutMe
        case 2:
            return .cardThingsILove
        case 3:
            return .cardGrowingUp
        case 4:
            return .cardFamilyLife
        case 5:
            return .cardMyPeople
        case 6:
            return .cardDailyLife
        case 7:
            return .cardSocialEnergy
        case 8:
            return .cardMoneyNPriorities
        case 9:
            return .cardWorkNAmbition
        case 10:
            return .cardWhatMattersToMe
        case 11:
            return .cardRightNWrong
        case 12:
            return .cardMeaningFulLife
        case 13:
            return .cardBeliefsNWorldview
        case 14:
            return .cardFirstConnections
        case 15:
            return .cardHealtyRelationships
        case 16:
            return .cardCommunication
        case 17:
            return .cardQualityTime
        case 18:
            return .cardLoveInTheFuture
        case 19:
            return .cardFeelings
        case 20:
            return .cardEmotionalSafety
        case 21:
            return .cardStressNBadDays
        case 22:
            return .cardConflictNRepair
        case 23:
            return .cardHiddenSides
        case 24:
            return .cardFutureMe
        case 25:
            return .cardDreamLife
        default:
            return .surfaceSecondary
        }
    }
}
