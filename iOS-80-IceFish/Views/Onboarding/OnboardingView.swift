import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var loc: LocalizationService
    @ObservedObject var viewModel: OnboardingViewModel

    private let heroHeight: CGFloat = 460
    private let contentOverlap: CGFloat = 64
    private let horizontalPadding: CGFloat = 28

    var body: some View {
        ZStack {
            AppScreenBackgroundView()

            VStack(spacing: 0) {
                heroSection
                    .clipped()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(edges: .top)
                contentSection
            }
        }
    }

    @ViewBuilder
    private var heroSection: some View {
        ZStack(alignment: .top) {
            switch viewModel.currentSlide {
            case .language:
                ColorPalette.background
                languageHeroCard
            default:
                if let name = viewModel.currentSlide.heroImageAssetName {
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                }
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.3),
                        Color.black.opacity(0),
                        Color.black.opacity(0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                LinearGradient(
                    colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.6),
                        Color.white
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0.4),
                    endPoint: .bottom
                )
            }

            skipButton
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 48)
                .padding(.trailing, 16)
        }
    }

    private var languageHeroCard: some View {
        VStack {
            Spacer()
            VStack(spacing: 8) {
                languageRowEnglish
                divider
                languageRowGerman
            }
            .padding(16)
            .frame(maxWidth: 350)
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(ColorPalette.cardBorder, lineWidth: 1)
            )
            Spacer()
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(ColorPalette.divider)
            .frame(height: 1)
            .frame(maxWidth: 308)
    }

    private var languageRowEnglish: some View {
        Button {
            viewModel.selectLanguage(.en)
        } label: {
            HStack(spacing: 0) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                loc.language == .en
                                    ? Color.white.opacity(0.2)
                                    : ColorPalette.germanRowFlagBackground
                            )
                        Text("🇺🇸")
                            .font(.system(size: 18))
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(loc.localized("onboarding.language.english"))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(
                                loc.language == .en
                                    ? ColorPalette.background
                                    : ColorPalette.textOnGradientDark
                            )
                        Text(loc.localized("onboarding.language.english_subtitle"))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(
                                loc.language == .en
                                    ? ColorPalette.textOnGradient
                                    : ColorPalette.textMuted
                            )
                    }
                }

                Spacer(minLength: 8)

                if loc.language == .en {
                    HStack(spacing: 8) {
                        Text(loc.localized("onboarding.language.active"))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(ColorPalette.background)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(ColorPalette.activePillFill)
                                    .overlay(
                                        Capsule()
                                            .stroke(ColorPalette.activePillStroke, lineWidth: 1)
                                    )
                            )
                        Image("OnboardingCheckCircle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                    }
                } else {
                    Circle()
                        .stroke(ColorPalette.radioStroke, lineWidth: 2)
                        .frame(width: 20, height: 20)
                }
            }
            .padding(12)
            .background(
                Group {
                    if loc.language == .en {
                        LinearGradient(
                            colors: [
                                ColorPalette.languageRowGradientStart,
                                ColorPalette.languageRowGradientEnd
                            ],
                            startPoint: UnitPoint(x: 0.1, y: 0),
                            endPoint: UnitPoint(x: 0.9, y: 1)
                        )
                    } else {
                        ColorPalette.background
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        loc.language == .en ? Color.clear : ColorPalette.cardBorder.opacity(0.6),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var languageRowGerman: some View {
        Button {
            viewModel.selectLanguage(.de)
        } label: {
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(ColorPalette.germanRowFlagBackground)
                        Text("🇩🇪")
                            .font(.system(size: 18))
                    }
                    .frame(width: 36, height: 36)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(loc.localized("onboarding.language.german"))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(ColorPalette.textOnGradientDark)
                        Text(loc.localized("onboarding.language.german_subtitle"))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(ColorPalette.textMuted)
                    }
                }

                Spacer(minLength: 8)

                ZStack {
                    Circle()
                        .stroke(ColorPalette.radioStroke, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if loc.language == .de {
                        Circle()
                            .fill(ColorPalette.gradientMid)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(12)
        }
        .buttonStyle(.plain)
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(loc.localized(viewModel.currentSlide.titleKey))
                .font(.system(size: 30, weight: .heavy))
                .foregroundColor(ColorPalette.textPrimary)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 16)

            Text(loc.localized(viewModel.currentSlide.subtitleKey))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(ColorPalette.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            if viewModel.currentSlide.showsPageIndicators {
                HStack(alignment: .center) {
                    OnboardingPageIndicators(activeIndex: viewModel.slideIndex)
                    Spacer()
                    nextButton
                }
                .padding(.top, 24)
            } else {
                HStack {
                    Spacer()
                    nextButton
                }
                .padding(.top, 24)
                .frame(height: 56, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 60)
        .background(ColorPalette.background)
    }

    private var skipButton: some View {
        Button {
            viewModel.skip()
        } label: {
            Text(loc.localized("onboarding.skip"))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(
                    viewModel.currentSlide == .language
                        ? ColorPalette.textPrimary
                        : ColorPalette.background
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    viewModel.currentSlide == .language
                        ? Color.black.opacity(0.06)
                        : ColorPalette.skipFill
                )
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            viewModel.currentSlide == .language
                                ? Color.black.opacity(0.12)
                                : ColorPalette.skipStroke,
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }

    private var nextButton: some View {
        Button {
            viewModel.advance()
        } label: {
            HStack(spacing: 12) {
                Text(loc.localized("onboarding.next"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.background)
                Image("OnboardingNextArrow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [
                        ColorPalette.gradientStart,
                        ColorPalette.gradientMid,
                        ColorPalette.gradientEnd
                    ],
                    startPoint: UnitPoint(x: 0.2, y: 0),
                    endPoint: UnitPoint(x: 0.8, y: 1)
                )
            )
            .clipShape(Capsule())
            .shadow(color: ColorPalette.shadowBlue, radius: 15, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
        .environmentObject(LocalizationService.shared)
}
