//
//  AppButton.swift
//  DatingCard
//

import SwiftUI

enum AppButtonVariant {
    case primary
    case secondary
}

struct AppButton: View {
    let title: String
    var variant: AppButtonVariant = .primary
    var isEnabled: Bool = true
    var accentColor: Color = .accentPrimary
    var showsBorder: Bool = true
    var disabledOpacity: Double = 0.45
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.headlineSemibold)
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Spacing.md)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Radius.clickable))
                .overlay {
                    if variant == .secondary && showsBorder {
                        RoundedRectangle(cornerRadius: Radius.clickable)
                            .stroke(Color.border, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : disabledOpacity)
    }

    private var foregroundColor: Color {
        variant == .primary ? .bgCard : accentColor
    }

    private var backgroundColor: Color {
        variant == .primary ? accentColor : .bgCard
    }
}
#Preview {
    VStack(spacing: Spacing.md) {
        AppButton(title: "Mulai") { }
        AppButton(title: "Kembali", variant: .secondary) { }
        AppButton(title: "Lanjut", isEnabled: false) { }
    }
    .padding(Spacing.lg)
    .background(Color.bgPrimary)
}
