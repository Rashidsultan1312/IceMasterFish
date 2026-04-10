import SwiftUI

struct FloatingTabBar: View {
    @EnvironmentObject private var loc: LocalizationService
    @Binding var selectedTab: AppTab

    private var barGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255),
                Color(red: 29 / 255, green: 78 / 255, blue: 216 / 255),
                Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                tabButton(tab)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(barGradient)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(ColorPalette.tabBarBorder, lineWidth: 1)
        )
        .shadow(color: ColorPalette.shadowBlue.opacity(0.55), radius: 14, x: 0, y: 8)
    }

    @ViewBuilder
    private func tabButton(_ tab: AppTab) -> some View {
        let isSelected = selectedTab == tab
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 999, style: .continuous)
                        .fill(Color.white.opacity(0.22))
                        .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 59)
                }

                VStack(spacing: 3.5) {
                    Image(tab.iconAssetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0), radius: 2, x: 0, y: 2)

                    Text(loc.localized(tab.shortLabelKey))
                        .font(.system(size: 10, weight: isSelected ? .bold : .semibold))
                        .foregroundColor(isSelected ? ColorPalette.background : ColorPalette.tabInactiveLabel)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .padding(.vertical, 10)
                .opacity(isSelected ? 1 : 0.6)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FloatingTabBarPreviewHost()
}

private struct FloatingTabBarPreviewHost: View {
    @State private var tab = AppTab.teams

    var body: some View {
        FloatingTabBar(selectedTab: $tab)
            .padding()
            .background(ColorPalette.textSecondary.opacity(0.15))
            .environmentObject(LocalizationService.shared)
    }
}
