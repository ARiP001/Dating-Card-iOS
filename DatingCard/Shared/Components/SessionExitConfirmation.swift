import SwiftUI

struct SessionExitConfirmation: View {
    var title: String = "Akhiri Sesi Obrolan"
    var message: String = "Apakah kamu yakin ingin mengakhiri sesi ini, Jika sesi diakhiri, kamu dapat melanjutkannya kembali melalui riwayat permainan."
    var continueTitle: String = "Lanjutkan Obrolan"
    var exitTitle: String = "Ya, Lanjutkan Nanti"
    let onContinue: () -> Void
    let onExit: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text(title)
                    .font(AppFont.title2Bold)
                
                Text(message)
                    .font(AppFont.title3Regular)
                    .foregroundStyle(Color.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(spacing: Spacing.sm) {
                    AppButton(title: continueTitle, action: onContinue)
                    
                    Button(action: onExit) {
                        Text(exitTitle)
                            .font(AppFont.headlineSemibold)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.md)
                            .background(Color(UIColor.secondarySystemBackground))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.xl)
            .background(Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: Radius.xl))
            .padding(Spacing.lg)
        }
    }
}
