//
//  AppScreenHeader.swift
//  DatingCard
//

import SwiftUI

struct AppScreenHeader: View {
    let title: String
    var leadingIcon: Image?
    var leadingAccessibilityLabel: String = ""
    var onLeadingTap: (() -> Void)?
    var trailingIcon: Image?
    var trailingAccessibilityLabel: String = ""
    var onTrailingTap: (() -> Void)?

    var body: some View {
        HStack(spacing: Spacing.sm) {
            headerButton(
                icon: leadingIcon,
                accessibilityLabel: leadingAccessibilityLabel,
                action: onLeadingTap
            )

            Text(title)
                .font(AppFont.headlineSemibold)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity)

            headerButton(
                icon: trailingIcon,
                accessibilityLabel: trailingAccessibilityLabel,
                action: onTrailingTap
            )
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }

    @ViewBuilder
    private func headerButton(
        icon: Image?,
        accessibilityLabel: String,
        action: (() -> Void)?
    ) -> some View {
        if let icon, let action {
            AppIconButton(
                icon: icon,
                accessibilityLabel: accessibilityLabel,
                action: action
            )
        } else {
            Color.clear
                .frame(width: 44, height: 44)
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        AppScreenHeader(
            title: "About Me",
            leadingIcon: Image(systemName: "chevron.left"),
            leadingAccessibilityLabel: "Kembali",
            onLeadingTap: { },
            trailingIcon: Image(systemName: "xmark"),
            trailingAccessibilityLabel: "Tutup",
            onTrailingTap: { }
        )
        Spacer()
    }
    .background(Color.bgPrimary)
}
