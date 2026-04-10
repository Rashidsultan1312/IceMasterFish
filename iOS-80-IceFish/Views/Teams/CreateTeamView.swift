import PhotosUI
import SwiftUI
import UIKit

struct CreateTeamView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var loc: LocalizationService
    @StateObject private var viewModel = CreateTeamViewModel()
    @State private var photoPickerItem: PhotosPickerItem?

    var existingTeam: Team? = nil
    var onSave: ((Team) -> Void)? = nil
    var onAutosave: ((Team) -> Void)? = nil

    private var submitGradient: LinearGradient {
        ColorPalette.navigationBarLinearGradient
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized(existingTeam == nil ? "create_team.title" : "create_team.title_edit"),
                        backButtonImageName: "CreateTeamBack",
                        bottomPadding: 24,
                        shadowStyle: .softBlue
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {
                            teamNameSection
                            leagueSection
                            teamIconSection
                            if viewModel.customLogoImage != nil {
                                uploadedPreviewSection
                            }
                            rosterSection
                            additionalInfoSection
                            submitSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                        .padding(.bottom, 48)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            if let team = existingTeam {
                viewModel.loadFromTeam(team)
                if let onAutosave {
                    viewModel.enableAutosave(existingId: team.id, onAutosave: onAutosave)
                }
            }
        }
        .onDisappear {
            viewModel.disableAutosave()
        }
        .onChange(of: photoPickerItem) { newItem in
            Task {
                guard let newItem else { return }
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        viewModel.applyPickedImage(image, data: data, fileName: "team_logo.jpg")
                    }
                }
            }
        }
    }

    private var teamNameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_team.field.team_name"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            ZStack(alignment: .leading) {
                TextField("", text: $viewModel.teamName, prompt: Text(loc.localized("create_team.placeholder.team_name"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.formPlaceholder))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.squadHeading)
                    .padding(.leading, 44)
                    .padding(.trailing, 16)
                    .padding(.vertical, 15)
                    .background(ColorPalette.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)

                Image("CreateTeamFieldEdit")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.leading, 16)
            }
        }
    }

    private var leagueSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_team.field.league"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            HStack(spacing: 6) {
                ForEach(TeamLeagueType.allCases) { league in
                    leagueChip(league)
                }
            }
            .padding(6)
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
        }
    }

    private func leagueChip(_ league: TeamLeagueType) -> some View {
        let selected = viewModel.leagueType == league
        return Button {
            viewModel.leagueType = league
        } label: {
            HStack(spacing: 8) {
                Image(league == .pro ? "CreateTeamLeaguePro" : "CreateTeamLeagueAmateur")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(loc.localized(league.localizationKey))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(selected ? ColorPalette.background : ColorPalette.leagueInactiveText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                Group {
                    if selected {
                        ColorPalette.leagueSegmentFill
                    } else {
                        Color.clear
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var teamIconSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom, spacing: 12) {
                Text(loc.localized("create_team.field.team_icon"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.squadHeading)
                Spacer(minLength: 0)
                Text(loc.localized("create_team.field.team_icon_hint"))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(ColorPalette.leagueSegmentFill)
            }

            Grid(alignment: .center, horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    ForEach(0..<4, id: \.self) { index in
                        presetCell(index: index)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                GridRow {
                    presetCell(index: 4)
                        .aspectRatio(1, contentMode: .fit)
                    presetCell(index: 5)
                        .aspectRatio(1, contentMode: .fit)
                    uploadCell
                        .gridCellColumns(2)
                }
            }
        }
    }

    private func presetCell(index: Int) -> some View {
        let selected = viewModel.selectedPresetIndex == index && viewModel.customLogoImage == nil
        return Button {
            photoPickerItem = nil
            viewModel.selectPreset(index)
        } label: {
            Image(viewModel.presetImageName(at: index))
                .resizable()
                .scaledToFit()
                .padding(selected ? 6 : 0)
                .frame(width: 82, height: 82)
                .background(selected ? ColorPalette.presetSelectedFill : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(ColorPalette.presetSelectedStroke, lineWidth: selected ? 3 : 0)
                )
                .shadow(
                    color: Color.black.opacity(selected ? 0.05 : 0),
                    radius: selected ? 2 : 0,
                    x: 0,
                    y: selected ? 1 : 0
                )
        }
        .buttonStyle(.plain)
    }

    private var uploadCell: some View {
        PhotosPicker(selection: $photoPickerItem, matching: .images) {
            HStack(spacing: 8) {
                Image("CreateTeamUploadIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(loc.localized("create_team.upload.label"))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.leagueInactiveText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 27)
            .padding(.horizontal, 24)
            .background(ColorPalette.uploadAreaFill)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ColorPalette.uploadDashStroke, style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
            )
        }
        .buttonStyle(.plain)
    }

    private var uploadedPreviewSection: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    Circle()
                        .fill(ColorPalette.presetSelectedFill)
                        .frame(width: 128, height: 128)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 4)
                        )

                    if let img = viewModel.customLogoImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                }
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 4)
                .shadow(color: Color.black.opacity(0.1), radius: 7, x: 0, y: 10)

                Button {
                    viewModel.clearCustomLogo()
                    photoPickerItem = nil
                } label: {
                    Image("CreateTeamRemoveUpload")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .padding(8)
                        .background(ColorPalette.removeBadgeRed)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                .buttonStyle(.plain)
                .offset(x: 4, y: -8)
            }
            .frame(width: 128, height: 128)

            VStack(spacing: 2) {
                Text(viewModel.customLogoFileName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.aiCardTitle)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                Text(byteCountString(viewModel.customLogoByteCount))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(ColorPalette.leagueSegmentFill)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(ColorPalette.background)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    private func byteCountString(_ bytes: Int) -> String {
        let mb = Double(bytes) / 1_048_576
        if mb >= 0.1 {
            return String(format: "%.1f MB", mb)
        }
        let kb = Double(bytes) / 1024
        return String(format: "%.0f KB", kb)
    }

    private var rosterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .bottom) {
                Text(loc.localized("create_team.roster.title"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.squadHeading)
                Spacer()
                Text(viewModel.rosterCountFormat(loc: loc))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(ColorPalette.rosterBadgeText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ColorPalette.rosterBadgeBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }

            HStack(alignment: .center, spacing: 8) {
                ZStack(alignment: .leading) {
                    TextField("", text: $viewModel.draftPlayerName, prompt: Text(loc.localized("create_team.placeholder.player"))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorPalette.formPlaceholder))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorPalette.squadHeading)
                        .padding(.leading, 36)
                        .padding(.trailing, 12)
                        .padding(.vertical, 12)
                        .background(ColorPalette.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)

                    Image("CreateTeamPlayerFieldIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .padding(.leading, 12)
                }
                .frame(maxWidth: .infinity)

                Button {
                    viewModel.addPlayerFromDraft()
                } label: {
                    Text(loc.localized("create_team.roster.add"))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorPalette.rosterBadgeText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(ColorPalette.rosterBadgeBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 8) {
                ForEach(viewModel.players) { player in
                    playerRow(player)
                }
            }
        }
    }

    private func playerRow(_ player: RosterPlayerDraft) -> some View {
        HStack(spacing: 12) {
            ZStack {
                if player.useFilledAvatar {
                    Circle()
                        .fill(ColorPalette.rosterBadgeBackground)
                        .frame(width: 32, height: 32)
                    Text(player.initials)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(ColorPalette.leagueInactiveText)
                } else {
                    Circle()
                        .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 1)
                        .frame(width: 32, height: 32)
                    Text(player.initials)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(ColorPalette.playerAvatarAltText)
                }
            }

            Text(displayName(for: player))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.playerRowName)

            Spacer(minLength: 0)

            Button {
                viewModel.removePlayer(id: player.id)
            } label: {
                Image("CreateTeamRemovePlayer")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .padding(6)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(ColorPalette.background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ColorPalette.divider, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
    }

    private func displayName(for player: RosterPlayerDraft) -> String {
        if player.isCaptain {
            return player.name + loc.localized("create_team.roster.captain_suffix")
        }
        return player.name
    }

    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(loc.localized("create_team.field.additional"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.squadHeading)

            ZStack(alignment: .topLeading) {
                if viewModel.additionalInfo.isEmpty {
                    Text(loc.localized("create_team.placeholder.additional"))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(ColorPalette.formPlaceholder)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                TextEditor(text: $viewModel.additionalInfo)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(ColorPalette.squadHeading)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
            }
            .background(ColorPalette.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
        }
        .padding(.bottom, 24)
    }

    private var submitSection: some View {
        Button {
            guard let team = viewModel.makeTeam(existingId: existingTeam?.id) else { return }
            onSave?(team)
            dismiss()
        } label: {
            HStack(spacing: 12) {
                Image("CreateTeamSubmitIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(loc.localized(existingTeam == nil ? "create_team.submit" : "create_team.submit_save"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(submitGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CreateTeamView()
        .environmentObject(LocalizationService.shared)
}
