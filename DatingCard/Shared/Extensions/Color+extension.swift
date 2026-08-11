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
    static let bgPrimary = Color(hex: "#F7F7FA")
    static let bgCard = Color(hex: "#FFFFFF")
    static let surfaceSecondary = Color(hex: "#E7E7EB")
    static let accentPrimary = Color(hex: "#85858A")
    static let textPrimary = Color(hex: "#242428")
    static let textSecondary = Color(hex: "#626269")
    static let border = Color(hex: "#C7C7CD")
    
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

