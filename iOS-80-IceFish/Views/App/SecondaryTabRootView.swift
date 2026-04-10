import SwiftUI

struct SecondaryTabRootView: View {
    @EnvironmentObject private var loc: LocalizationService
    let tab: AppTab

    var body: some View {
        VStack(spacing: 12) {
            Text(loc.localized(tab.titleLocalizationKey))
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)
            Text(loc.localized("tab.placeholder.subtitle"))
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(ColorPalette.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SecondaryTabRootView(tab: .schedule)
        .environmentObject(LocalizationService.shared)
}
