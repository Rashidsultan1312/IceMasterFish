import StoreKit
import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var loc: LocalizationService

    private var screenGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.settingsScreenGradientStart,
                ColorPalette.settingsScreenGradientMid,
                ColorPalette.settingsScreenGradientEnd
            ],
            startPoint: UnitPoint(x: 0.02, y: 0.12),
            endPoint: UnitPoint(x: 0.98, y: 0.88)
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                screenGradient
                    .ignoresSafeArea()

                Image("SettingsDecorBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: min(geo.size.height * 0.4, 480))
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized("settings.nav_title"),
                        backButtonImageName: "SettingsNavBack",
                        titleLetterSpacing: -0.6
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            languageSection
                            legalSection
                            feedbackSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
    }

    private var languageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(iconAsset: "SettingsSectionLanguage", titleKey: "settings.section.language")
            VStack(spacing: 8) {
                languageRow(flag: "🇺🇸", titleKey: "settings.lang.english", subtitleKey: "settings.lang.english_subtitle", code: .en)
                Rectangle()
                    .fill(ColorPalette.divider)
                    .frame(height: 1)
                    .padding(.horizontal, 4)
                languageRow(flag: "🇩🇪", titleKey: "settings.lang.german", subtitleKey: "settings.lang.german_subtitle", code: .de)
            }
            .padding(16)
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(ColorPalette.cardBorder, lineWidth: 1)
            )
        }
    }

    private func languageRow(flag: String, titleKey: String, subtitleKey: String, code: LocalizationService.Language) -> some View {
        let isSelected = loc.language == code
        return Button {
            loc.language = code
        } label: {
            HStack(alignment: .center, spacing: 12) {
                Text(flag)
                    .font(.system(size: 18))
                    .frame(width: 36, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(isSelected ? Color.white.opacity(0.22) : ColorPalette.germanRowFlagBackground)
                    )
                    .shadow(color: isSelected ? Color.black.opacity(0.06) : .clear, radius: 2, x: 0, y: 1)

                VStack(alignment: .leading, spacing: 2) {
                    Text(loc.localized(titleKey))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(isSelected ? ColorPalette.background : ColorPalette.settingsRowTitle)
                    Text(loc.localized(subtitleKey))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isSelected ? ColorPalette.settingsLanguageMetaOnActive : ColorPalette.settingsRowSubtitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if isSelected {
                    Text(loc.localized("settings.lang.active"))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(ColorPalette.background)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 10)
                        .background(ColorPalette.activePillFill)
                        .clipShape(Capsule(style: .continuous))
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(ColorPalette.activePillStroke, lineWidth: 1)
                        )
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [ColorPalette.languageRowGradientStart, ColorPalette.languageRowGradientEnd],
                            startPoint: UnitPoint(x: 0.08, y: 0),
                            endPoint: UnitPoint(x: 0.95, y: 1)
                        )
                    } else {
                        Color.clear
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(iconAsset: "SettingsSectionLegal", titleKey: "settings.section.legal")
            VStack(spacing: 0) {
                legalButton(
                    iconAsset: "SettingsRowPrivacy",
                    titleKey: "settings.legal.privacy.title",
                    subtitleKey: "settings.legal.privacy.subtitle"
                ) {
                    openURL(SettingsExternalLinks.privacy)
                }
                Rectangle()
                    .fill(ColorPalette.divider)
                    .frame(height: 1)
                legalButton(
                    iconAsset: "SettingsRowTerms",
                    titleKey: "settings.legal.terms.title",
                    subtitleKey: "settings.legal.terms.subtitle"
                ) {
                    openURL(SettingsExternalLinks.terms)
                }
                Rectangle()
                    .fill(ColorPalette.divider)
                    .frame(height: 1)
                legalButton(
                    iconAsset: "SettingsRowSupport",
                    titleKey: "settings.legal.support.title",
                    subtitleKey: "settings.legal.support.subtitle"
                ) {
                    openURL(SettingsExternalLinks.support)
                }
            }
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(ColorPalette.cardBorder, lineWidth: 1)
            )
        }
    }

    private func legalButton(iconAsset: String, titleKey: String, subtitleKey: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(iconAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(loc.localized(titleKey))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(ColorPalette.settingsRowTitle)
                    Text(loc.localized(subtitleKey))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(ColorPalette.settingsRowSubtitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image("SettingsChevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(iconAsset: "SettingsSectionFeedback", titleKey: "settings.section.feedback")
            Button {
                requestAppStoreReview()
            } label: {
                HStack(spacing: 16) {
                    Image("SettingsRateHero")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(loc.localized("settings.rate.title"))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ColorPalette.settingsRateTitle)
                        HStack(spacing: 4) {
                            ForEach(0..<5, id: \.self) { _ in
                                Image("SettingsStar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        Text(loc.localized("settings.rate.subtitle"))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(ColorPalette.settingsRowSubtitle)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Image("SettingsChevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorPalette.background)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(ColorPalette.cardBorder, lineWidth: 1)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
    }

    private func sectionHeader(iconAsset: String, titleKey: String) -> some View {
        HStack(spacing: 12) {
            Image(iconAsset)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Text(loc.localized(titleKey))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(ColorPalette.settingsSectionTitle)
        }
        .padding(.horizontal, 4)
    }

    private func requestAppStoreReview() {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}

private enum SettingsExternalLinks {
    static let privacy = URL(string: "https://sites.google.com/view/icy-master-fish/privacy-policy")!
    static let terms = URL(string: "https://sites.google.com/view/icy-master-fish/terms-of-use")!
    static let support = URL(string: "https://sites.google.com/view/icy-master-fish/support")!
}

#Preview {
    SettingsView()
        .environmentObject(LocalizationService.shared)
}
