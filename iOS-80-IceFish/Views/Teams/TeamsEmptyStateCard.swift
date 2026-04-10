import SwiftUI

struct TeamsEmptyStateCard: View {
    @EnvironmentObject private var loc: LocalizationService

    private let corner: CGFloat = 28

    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(ColorPalette.background)

            decorativeBlobs

            VStack(spacing: 0) {
                Image("EmptyTeamsIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .padding(.bottom, 20)

                Text(loc.localized("teams.empty.title"))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ColorPalette.squadHeading)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)

                Text(loc.localized("teams.empty.message"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(ColorPalette.emptyStateBody)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 8)
            }
            .padding(32)
        }
        .overlay(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private var decorativeBlobs: some View {
        ZStack {
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            ColorPalette.teamCardGradientBlob,
                            ColorPalette.cardBorder.opacity(0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 128, height: 128)
                .opacity(0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: 40, y: -20)
                .allowsHitTesting(false)

            RoundedRectangle(cornerRadius: 999, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            ColorPalette.teamCardGradientBlob,
                            ColorPalette.background
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 96, height: 96)
                .opacity(0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .offset(x: -30, y: 40)
                .allowsHitTesting(false)
        }
        .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
    }
}

#Preview {
    TeamsEmptyStateCard()
        .environmentObject(LocalizationService.shared)
        .padding()
}
