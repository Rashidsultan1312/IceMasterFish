import Photos
import SwiftUI
import UIKit

struct AutoLogoGeneratorView: View {
    @EnvironmentObject private var loc: LocalizationService
    @StateObject private var viewModel = AutoLogoGeneratorViewModel()

    @State private var teamName: String = ""
    @State private var cityRegion: String = ""
    @State private var detailsText: String = ""
    @State private var selectedSwatch: Int = 0
    @State private var showResult: Bool = false
    @State private var showSaveSuccessAlert = false
    @State private var showSaveErrorAlert = false
    @State private var saveErrorMessageKey = "auto_logo.save_failed"
    @State private var isSavingToPhotos = false

    private let swatchCount = 5

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

    private var saveButtonGradient: LinearGradient {
        generateButtonGradient
    }

    private var resultCardGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.autoLogoResultCardGradientStart,
                ColorPalette.autoLogoResultCardGradientEnd
            ],
            startPoint: UnitPoint(x: 0.15, y: 0),
            endPoint: UnitPoint(x: 0.85, y: 1)
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()
                bodyGradient
                    .ignoresSafeArea()

                Image("AutoLogoDecor")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized("auto_logo.nav_title"),
                        backButtonImageName: "AutoLogoBack",
                        bottomPadding: 24,
                        shadowStyle: .softBlue
                    )

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            settingsCard
                            if let key = viewModel.errorMessageKey, showResult {
                                Text(loc.localized(key))
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(ColorPalette.removeBadgeRed)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            if showResult {
                                resultCard
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
        .alert(loc.localized("auto_logo.save_success_title"), isPresented: $showSaveSuccessAlert) {
            Button(loc.localized("common.ok"), role: .cancel) {}
        } message: {
            Text(loc.localized("auto_logo.save_success_message"))
        }
        .alert(loc.localized("auto_logo.save_error_title"), isPresented: $showSaveErrorAlert) {
            Button(loc.localized("common.ok"), role: .cancel) {}
        } message: {
            Text(loc.localized(saveErrorMessageKey))
        }
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
                headerRow
                teamNameField
                cityField
                colorSwatchesSection
                detailsSection
                generateButton
            }
            .padding(20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private var headerRow: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("AutoLogoHeaderBadge")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(loc.localized("auto_logo.section.design_title"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
                Text(loc.localized("auto_logo.section.design_subtitle"))
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
    }

    private var teamNameField: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image("AutoLogoTeamFieldIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(loc.localized("auto_logo.field.team_name"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            TextField("", text: $teamName, prompt: Text(loc.localized("auto_logo.demo_team"))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ColorPalette.formPlaceholder))
                .font(.system(size: 16, weight: .semibold))
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

    private var cityField: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image("AutoLogoCityFieldIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(loc.localized("auto_logo.field.city"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            TextField("", text: $cityRegion, prompt: Text(loc.localized("auto_logo.placeholder.city"))
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

    private var logoSwatchPurplePinkGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 192 / 255, green: 132 / 255, blue: 252 / 255),
                Color(red: 236 / 255, green: 72 / 255, blue: 153 / 255),
                Color(red: 251 / 255, green: 146 / 255, blue: 60 / 255)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var colorSwatchesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image("AutoLogoColorsLabelIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(loc.localized("auto_logo.field.colors"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            HStack(spacing: 16) {
                ForEach(0..<swatchCount, id: \.self) { index in
                    logoColorSwatch(index: index)
                }
            }
            .padding(.top, 4)
        }
    }

    private func logoSwatchFill(for index: Int) -> some ShapeStyle {
        switch index {
        case 0:
            return AnyShapeStyle(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
        case 1:
            return AnyShapeStyle(Color(red: 20 / 255, green: 184 / 255, blue: 166 / 255))
        case 2:
            return AnyShapeStyle(logoSwatchPurplePinkGradient)
        case 3:
            return AnyShapeStyle(Color(red: 249 / 255, green: 115 / 255, blue: 22 / 255))
        case 4:
            return AnyShapeStyle(Color(red: 16 / 255, green: 185 / 255, blue: 129 / 255))
        case 5:
            return AnyShapeStyle(Color(red: 245 / 255, green: 158 / 255, blue: 11 / 255))
        default:
            return AnyShapeStyle(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
        }
    }

    private func logoColorSwatch(index: Int) -> some View {
        let isSelected = selectedSwatch == index
        return Button {
            selectedSwatch = index
        } label: {
            ZStack {
                Circle()
                    .fill(logoSwatchFill(for: index))
                    .frame(width: 40, height: 40)
                if isSelected {
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 44, height: 44)
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 44, height: 44)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image("AutoLogoDetailsIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(loc.localized("auto_logo.field.details"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            ZStack(alignment: .topLeading) {
                if detailsText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(loc.localized("auto_logo.placeholder.details"))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorPalette.formPlaceholder)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                }
                TextEditor(text: $detailsText)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorPalette.autoNameToneHint)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
            }
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
            showResult = true
            Task {
                await viewModel.generate(
                    teamName: teamName,
                    cityRegion: cityRegion,
                    swatchIndex: selectedSwatch,
                    details: detailsText,
                    regenerate: false
                )
            }
        } label: {
            HStack(spacing: 8) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(ColorPalette.background)
                } else {
                    Image("AutoLogoGenerateIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                Text(loc.localized(viewModel.isLoading ? "openai.status.generating" : "auto_logo.generate"))
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

    private var resultCard: some View {
        ZStack {
            resultCardGradient
            Circle()
                .fill(ColorPalette.leagueSegmentFill.opacity(0.2))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .offset(x: 100, y: -50)
            Circle()
                .fill(ColorPalette.teamLogoGlow.opacity(0.35))
                .frame(width: 160, height: 160)
                .blur(radius: 40)
                .offset(x: -90, y: 90)

            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    Image("AutoLogoCrestResultIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(loc.localized("auto_logo.result.title"))
                        .font(.system(size: 14, weight: .bold))
                        .tracking(0.7)
                        .foregroundColor(ColorPalette.autoLogoResultSubtitle)
                }

                VStack(spacing: 8) {
                    Text(resolvedTeamName)
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(ColorPalette.background)
                        .multilineTextAlignment(.center)

                    Text(resultSubtitleText)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorPalette.autoLogoResultSubtitle)
                }
                .padding(.top, 24)
                .padding(.bottom, 8)

                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(ColorPalette.background)
                            .frame(width: 120, height: 120)
                    } else if let uiImage = viewModel.generatedImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image("AutoLogoSampleCrest")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .padding(12)
                .frame(maxWidth: 220)
                    .background(ColorPalette.autoLogoCrestFrameFill)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(ColorPalette.autoLogoCrestFrameStroke, lineWidth: 1)
                    )
                    .padding(10)
                    .background(ColorPalette.background.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(ColorPalette.autoLogoCrestFrameStroke, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
                    .padding(.top, 8)

                Rectangle()
                    .fill(ColorPalette.rosterBadgeText.opacity(0.35))
                    .frame(height: 1)
                    .padding(.top, 24)

                HStack(spacing: 12) {
                    Button {
                        Task {
                            await viewModel.generate(
                                teamName: teamName,
                                cityRegion: cityRegion,
                                swatchIndex: selectedSwatch,
                                details: detailsText,
                                regenerate: true
                            )
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image("AutoLogoRegenerateIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Text(loc.localized("auto_logo.regenerate"))
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
                    .disabled(viewModel.isLoading)

                    Button {
                        Task { await saveCrestToPhotos() }
                    } label: {
                        HStack(spacing: 8) {
                            if isSavingToPhotos {
                                ProgressView()
                                    .tint(ColorPalette.background)
                            } else {
                                Image("AutoLogoSaveIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                            }
                            Text(loc.localized("auto_logo.save"))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorPalette.background)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(saveButtonGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.isLoading || isSavingToPhotos)
                }
                .padding(.top, 16)
            }
            .padding(24)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var resolvedTeamName: String {
        let t = teamName.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? loc.localized("auto_logo.demo_team") : t
    }

    private var resultSubtitleText: String {
        let theme = loc.localized(themeKey(for: selectedSwatch))
        let region = cityRegion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? loc.localized("auto_logo.result.region_fallback")
            : cityRegion.trimmingCharacters(in: .whitespacesAndNewlines)
        return String(format: loc.localized("auto_logo.result.subtitle_format"), theme, region)
    }

    private func themeKey(for index: Int) -> String {
        switch index {
        case 0: return "auto_logo.theme_blue"
        case 1: return "auto_logo.theme_teal"
        case 2: return "auto_logo.theme_purple"
        case 3: return "auto_logo.theme_orange"
        case 4: return "auto_logo.theme_green"
        case 5: return "auto_logo.theme_amber"
        default: return "auto_logo.theme_blue"
        }
    }

    private func saveCrestToPhotos() async {
        let image = viewModel.generatedImage ?? UIImage(named: "AutoLogoSampleCrest")
        guard let image else {
            saveErrorMessageKey = "auto_logo.save_no_image"
            showSaveErrorAlert = true
            return
        }

        isSavingToPhotos = true
        defer { isSavingToPhotos = false }

        let status = await requestPhotoAddAuthorization()
        guard status == .authorized || status == .limited else {
            saveErrorMessageKey = "auto_logo.save_permission_denied"
            showSaveErrorAlert = true
            return
        }

        do {
            try await performSaveImageToPhotoLibrary(image)
            showSaveSuccessAlert = true
        } catch {
            saveErrorMessageKey = "auto_logo.save_failed"
            showSaveErrorAlert = true
        }
    }

    private func requestPhotoAddAuthorization() async -> PHAuthorizationStatus {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                continuation.resume(returning: status)
            }
        }
    }

    private func performSaveImageToPhotoLibrary(_ image: UIImage) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: PhotoLibrarySaveError.unknownFailure)
                }
            }
        }
    }
}

private enum PhotoLibrarySaveError: Error {
    case unknownFailure
}

#Preview {
    AutoLogoGeneratorView()
        .environmentObject(LocalizationService.shared)
}
