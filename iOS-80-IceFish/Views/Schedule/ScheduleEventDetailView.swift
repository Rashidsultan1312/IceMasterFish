import SwiftUI

struct ScheduleEventDetailView: View {
    @EnvironmentObject private var loc: LocalizationService

    let event: ScheduleEvent
    let teams: [Team]
    var onEdit: () -> Void
    var onDelete: () -> Void

    @State private var confirmDelete = false

    private var screenBackdrop: LinearGradient {
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

    private var deleteGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.deleteButtonGradientStart,
                ColorPalette.deleteButtonGradientMid,
                ColorPalette.deleteButtonGradientEnd
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var resolvedTeam: Team? {
        guard let id = event.teamId else { return nil }
        return teams.first { $0.id == id }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()
                screenBackdrop
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: event.title,
                        backButtonImageName: "CreateEventBack",
                        bottomPadding: 24,
                        titleMinimumScaleFactor: 0.75,
                        shadowStyle: .softBlue
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 32) {
                            eventNameSection
                            dateSection
                            timeSection
                            locationSection
                            teamSection
                            notesSection
                            actionButtons
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 48)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
        .alert(loc.localized("schedule.detail.delete_confirm_title"), isPresented: $confirmDelete) {
            Button(loc.localized("schedule.detail.delete_cancel"), role: .cancel) {}
            Button(loc.localized("schedule.detail.delete_confirm"), role: .destructive) {
                onDelete()
            }
        } message: {
            Text(loc.localized("schedule.detail.delete_confirm_message"))
        }
    }

    private var eventNameSection: some View {
        formCard {
            sectionHeader(iconName: "CreateEventNameIcon", titleKey: "create_event.field.name")
            readOnlyBox(text: event.title)
        }
    }

    private var dateSection: some View {
        formCard {
            sectionHeader(iconName: "CreateEventDateIcon", titleKey: "create_event.field.date")
            HStack {
                Text(dateFormatted)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.autoNameToneHint)
                Spacer(minLength: 8)
                Image("CreateEventDatePickerGlyph")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(ColorPalette.presetSelectedFill)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
            )
        }
    }

    private var timeSection: some View {
        formCard {
            sectionHeader(iconName: "CreateEventTimeSectionIcon", titleKey: "create_event.field.time")

            VStack(alignment: .leading, spacing: 12) {
                Text(loc.localized("create_event.time.start"))
                    .font(.system(size: 12, weight: .bold))
                    .tracking(0.6)
                    .foregroundColor(ColorPalette.createEventTimeRowLabel)

                readOnlyTimeRow(iconName: "CreateEventClockStart", date: event.startDateTime)

                Text(loc.localized("create_event.time.end"))
                    .font(.system(size: 12, weight: .bold))
                    .tracking(0.6)
                    .foregroundColor(ColorPalette.createEventTimeRowLabel)

                readOnlyTimeRow(iconName: "CreateEventClockEnd", date: event.endDateTime)
            }

            durationBadge
        }
    }

    private func readOnlyTimeRow(iconName: String, date: Date) -> some View {
        HStack(spacing: 10) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Text(timeFormatted(date))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ColorPalette.autoNameToneHint)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(ColorPalette.presetSelectedFill)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
        )
    }

    private var durationBadge: some View {
        HStack(spacing: 10) {
            Image("CreateEventDurationIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Text(loc.localized("create_event.duration.label"))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.createEventDurationLabel)
            Text(detailDurationText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorPalette.createEventDurationValue)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(ColorPalette.presetSelectedFill)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private var detailDurationText: String {
        let s = event.startDateTime
        let e = event.endDateTime
        guard e > s else { return loc.localized("create_event.duration.placeholder") }
        let minutes = Int(e.timeIntervalSince(s) / 60)
        let h = minutes / 60
        let m = minutes % 60
        return String(format: loc.localized("create_event.duration.format"), h, m)
    }

    private var locationSection: some View {
        formCard {
            sectionHeader(iconName: "CreateEventLocationIcon", titleKey: "create_event.field.location")
            readOnlyBox(text: event.location.isEmpty ? loc.localized("schedule.detail.location_empty") : event.location)
        }
    }

    private var teamSection: some View {
        formCard {
            sectionHeader(iconName: "CreateEventTeamSectionIcon", titleKey: "create_event.field.team")
            if let team = resolvedTeam {
                teamReadOnlyRow(team: team)
            } else {
                readOnlyBox(text: loc.localized("schedule.detail.no_team"))
            }
        }
    }

    private func teamReadOnlyRow(team: Team) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(ColorPalette.createEventTeamRowSelectedStroke, lineWidth: 2)
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(ColorPalette.createEventTeamRadioInnerFill)
                    .frame(width: 10, height: 10)
            }

            TeamLogoThumb(team: team)
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(ColorPalette.cardBorder, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(team.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
                Text(String(format: loc.localized("create_event.team.meta_format"), team.players.count, loc.localized("create_event.team.active")))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(ColorPalette.createEventDurationValue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            LinearGradient(
                colors: [
                    ColorPalette.createEventTeamRowSelectedFillStart,
                    ColorPalette.createEventTeamRowSelectedFillEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ColorPalette.createEventTeamRowSelectedStroke, lineWidth: 2)
        )
    }

    private var notesSection: some View {
        formCard {
            HStack(spacing: 12) {
                Image("CreateEventNotesIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text(loc.localized("create_event.field.notes"))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)

                Spacer()

                Text(loc.localized("create_event.notes.optional_badge"))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(ColorPalette.formPlaceholder)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(ColorPalette.presetSelectedFill)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(ColorPalette.cardBorder, lineWidth: 1)
                    )
            }

            Text(event.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? loc.localized("schedule.detail.notes_empty")
                : event.notes)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(
                    event.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? ColorPalette.formPlaceholder
                        : ColorPalette.autoNameToneHint
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(ColorPalette.presetSelectedFill)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
                )
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button {
                onEdit()
            } label: {
                Text(loc.localized("schedule.detail.edit"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorPalette.navigationBarLinearGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 12, x: 0, y: 6)
            }
            .buttonStyle(.plain)

            Button {
                confirmDelete = true
            } label: {
                Text(loc.localized("schedule.detail.delete"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(deleteGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
    }

    private func readOnlyBox(text: String) -> some View {
        Text(text)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(ColorPalette.autoNameToneHint)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(ColorPalette.presetSelectedFill)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(ColorPalette.formFieldStrokeBold, lineWidth: 2)
            )
    }

    private var dateFormatted: String {
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.setLocalizedDateFormatFromTemplate("yMMMd")
        return df.string(from: event.startDateTime)
    }

    private func timeFormatted(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.timeStyle = .short
        return df.string(from: date)
    }

    @ViewBuilder
    private func formCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(ColorPalette.background)

            VStack(alignment: .leading, spacing: 12) {
                content()
            }
            .padding(20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private func sectionHeader(iconName: String, titleKey: String) -> some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(loc.localized(titleKey))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(ColorPalette.autoNameSectionLabel)
        }
        .padding(.bottom, 4)
    }
}

#Preview {
    let cal = Calendar.current
    let day = cal.date(from: DateComponents(year: 2025, month: 2, day: 14))!
    let start = cal.date(bySettingHour: 9, minute: 0, second: 0, of: day) ?? day
    let end = cal.date(bySettingHour: 13, minute: 0, second: 0, of: day) ?? day
    let ev = ScheduleEvent(
        id: UUID(),
        title: "Trophy Catch Session",
        startDateTime: start,
        endDateTime: end,
        location: "Lake Michigan, North Pier",
        notes: "Bring extra auger blades.",
        teamId: Team.previewLakeWalkers.id
    )
    return ScheduleEventDetailView(event: ev, teams: [Team.previewLakeWalkers], onEdit: {}, onDelete: {})
        .environmentObject(LocalizationService.shared)
}
