//
//  AppIconButton.swift
//  DatingCard
//

import SwiftUI

struct AppIconButton: View {
    let icon: Image
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color.textPrimary)
                .frame(width: 44, height: 44)
                .background(Color.bgCard)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.border, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview {
    HStack(spacing: Spacing.md) {
        AppIconButton(
            icon: Image(systemName: "chevron.left"),
            accessibilityLabel: "Kembali"
        ) { }

        AppIconButton(
            icon: Image(systemName: "xmark"),
            accessibilityLabel: "Tutup"
        ) { }
    }
    .padding(Spacing.lg)
    .background(Color.bgPrimary)
}
