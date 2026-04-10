import SwiftUI
import UIKit

struct AutoNameGeneratorView: View {
    @EnvironmentObject private var loc: LocalizationService
    @StateObject private var viewModel = AutoNameGeneratorViewModel()

    @State private var selectedWord: AutoNameWordOption = .two
    @State private var selectedTone: AutoNameToneOption = .entertaining
    @State private var exampleText: String = ""

    private var bodyGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.teamDetailBodyGradientStart,
                ColorPalette.teamDetailBodyGradientMid,
                ColorPalette.teamDetailBodyGradientEnd
            ],
            startPoint: UnitPoint(x: 0.02, y: 0),
            endPoint: UnitPoint(x: 0.98, y: 1)
        )
    }

    private var generateButtonGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.navigationBarGradientMid,
                ColorPalette.navigationBarGradientEnd
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var resultCardGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.autoNameResultCardGradientStart,
                ColorPalette.autoNameResultCardGradientEnd
            ],
            startPoint: UnitPoint(x: 0.2, y: 0),
            endPoint: UnitPoint(x: 0.9, y: 1)
        )
    }

    private var regenerateGradient: LinearGradient {
        generateButtonGradient
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()
                bodyGradient
                    .ignoresSafeArea()

                Image("AutoNameDecor")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized("auto_name.nav_title"),
                        backButtonImageName: "AutoNameBack",
                        bottomPadding: 24,
                        shadowStyle: .softBlue
                    )

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            settingsCard
                            if let key = viewModel.errorMessageKey {
                                Text(loc.localized(key))
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(ColorPalette.removeBadgeRed)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            if let name = viewModel.generatedName {
                                resultCard(name: name)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
    }

    private var settingsCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(ColorPalette.background)

            RoundedRectangle(cornerRadius: 999, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            ColorPalette.teamCardGradientBlob,
                            ColorPalette.cardBorder.opacity(0.95)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 128, height: 128)
                .opacity(0.5)
                .offset(x: 24, y: -32)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top, spacing: 12) {
                    Image("AutoNameHeaderBadge")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(loc.localized("auto_name.section.settings_title"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(ColorPalette.autoNameSectionLabel)
                        Text(loc.localized("auto_name.section.settings_subtitle"))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(ColorPalette.leagueSegmentFill)
                    }
                }
                .padding(.bottom, 4)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(ColorPalette.divider)
                        .frame(height: 1)
                }

                wordCountSection
                toneSection
                exampleSection
                generateButton
            }
            .padding(20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private var wordCountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image("AutoNameWordsIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(loc.localized("auto_name.words.label"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            HStack(spacing: 8) {
                ForEach(AutoNameWordOption.allCases) { option in
                    wordChip(option: option)
                }
            }
        }
    }

    private func wordChip(option: AutoNameWordOption) -> some View {
        let selected = selectedWord == option
        return Button {
            selectedWord = option
        } label: {
            Text(wordOptionTitle(option))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(selected ? ColorPalette.background : ColorPalette.autoNameToneHint)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(selected ? ColorPalette.leagueSegmentFill : ColorPalette.background)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(
                            selected ? ColorPalette.leagueSegmentFill : ColorPalette.formFieldStrokeBold,
                            lineWidth: 2
                        )
                )
        }
        .buttonStyle(.plain)
    }

    private var toneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(ColorPalette.leagueSegmentFill)
                    .frame(width: 16, height: 16)
                Text(loc.localized("auto_name.tone.label"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            VStack(spacing: 10) {
                toneRow(.strictProfessional, icon: "AutoNameToneStrictIcon")
                toneRow(.entertaining, icon: "AutoNameToneFunIcon")
                toneRow(.playful, icon: "AutoNameTonePlayfulIcon")
            }
        }
    }

    private func toneRow(_ tone: AutoNameToneOption, icon: String) -> some View {
        let selected = selectedTone == tone
        return Button {
            selectedTone = tone
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(loc.localized(toneTitleKey(tone)))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(selected ? ColorPalette.background : ColorPalette.autoNameToneHint)
                    Text(loc.localized(toneHintKey(tone)))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(selected ? ColorPalette.background.opacity(0.85) : ColorPalette.autoNameToneHint.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(14)
            .background(selected ? ColorPalette.leagueSegmentFill : ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        selected ? ColorPalette.leagueSegmentFill : ColorPalette.formFieldStrokeBold,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var exampleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image("AutoNameExampleIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(loc.localized("auto_name.example.label"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            TextField("", text: $exampleText, prompt: Text(loc.localized("auto_name.example.placeholder"))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorPalette.formPlaceholder))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorPalette.autoNameToneHint)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(ColorPalette.presetSelectedFill)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
                )
        }
    }

    private var generateButton: some View {
        Button {
            runGenerate()
        } label: {
            HStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(ColorPalette.background)
                } else {
                    Image("AutoNameGenerateIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                Text(loc.localized(viewModel.isLoading ? "openai.status.generating" : "auto_name.generate"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(generateButtonGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isLoading)
    }

    private func resultCard(name: String) -> some View {
        ZStack {
            resultCardGradient
            Circle()
                .fill(ColorPalette.leagueSegmentFill.opacity(0.2))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .offset(x: 100, y: -60)
            Circle()
                .fill(ColorPalette.teamLogoGlow.opacity(0.4))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .offset(x: -80, y: 80)

            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image("AutoNameResultIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(loc.localized("auto_name.result.title"))
                        .font(.system(size: 14, weight: .bold))
                        .tracking(0.7)
                        .foregroundColor(ColorPalette.autoNameResultSubtitle)
                }

                VStack(spacing: 8) {
                    Text(name)
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(ColorPalette.background)
                        .multilineTextAlignment(.center)
                        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)

                    Text(resultSubtitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorPalette.autoNameResultSubtitle)
                }
                .padding(.top, 24)
                .padding(.bottom, 8)

                Rectangle()
                    .fill(ColorPalette.rosterBadgeText.opacity(0.35))
                    .frame(height: 1)
                    .padding(.top, 16)

                HStack(spacing: 12) {
                    Button {
                        UIPasteboard.general.string = name
                    } label: {
                        HStack(spacing: 8) {
                            Image("AutoNameCopyIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Text(loc.localized("auto_name.copy"))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorPalette.background)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(ColorPalette.autoNameCopyButtonFill)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(ColorPalette.autoNameCopyButtonStroke, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    Button {
                        runRegenerate()
                    } label: {
                        HStack(spacing: 8) {
                            Image("AutoNameRegenerateIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Text(loc.localized("auto_name.regenerate"))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorPalette.background)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(regenerateGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading)
                }
                .padding(.top, 16)
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var resultSubtitle: String {
        let tone = loc.localized(toneTitleKey(selectedTone))
        let words = wordOptionTitle(selectedWord)
        return String(format: loc.localized("auto_name.result.subtitle_format"), tone, words)
    }

    private func wordOptionTitle(_ option: AutoNameWordOption) -> String {
        switch option {
        case .one: return loc.localized("auto_name.words.one")
        case .two: return loc.localized("auto_name.words.two")
        case .three: return loc.localized("auto_name.words.three")
        }
    }

    private func toneTitleKey(_ tone: AutoNameToneOption) -> String {
        switch tone {
        case .strictProfessional: return "auto_name.tone.strict_title"
        case .entertaining: return "auto_name.tone.fun_title"
        case .playful: return "auto_name.tone.playful_title"
        }
    }

    private func toneHintKey(_ tone: AutoNameToneOption) -> String {
        switch tone {
        case .strictProfessional: return "auto_name.tone.strict_hint"
        case .entertaining: return "auto_name.tone.fun_hint"
        case .playful: return "auto_name.tone.playful_hint"
        }
    }

    private func runGenerate() {
        Task {
            await viewModel.generate(wordCount: selectedWord, tone: selectedTone, exampleHint: exampleText)
        }
    }

    private func runRegenerate() {
        runGenerate()
    }
}

#Preview {
    AutoNameGeneratorView()
        .environmentObject(LocalizationService.shared)
}
