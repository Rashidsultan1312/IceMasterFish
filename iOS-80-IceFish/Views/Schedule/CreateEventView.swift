import PhotosUI
import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var loc: LocalizationService
    @StateObject private var viewModel: CreateEventViewModel
    @State private var coverPhotoPickerItem: PhotosPickerItem?

    private let existingEvent: ScheduleEvent?
    var onSave: (ScheduleEvent) -> Void

    init(teams: [Team], initialDay: Date, existingEvent: ScheduleEvent? = nil, onSave: @escaping (ScheduleEvent) -> Void) {
        self.existingEvent = existingEvent
        _viewModel = StateObject(wrappedValue: CreateEventViewModel(teams: teams, initialDay: initialDay, existingEvent: existingEvent))
        self.onSave = onSave
    }

    private var screenGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.createEventScreenGradientStart,
                ColorPalette.createEventScreenGradientMid,
                ColorPalette.createEventScreenGradientEnd
            ],
            startPoint: UnitPoint(x: 0.08, y: 0.92),
            endPoint: UnitPoint(x: 0.92, y: 0.08)
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                screenGradient
                    .ignoresSafeArea()

                Image("CreateEventBodyDecor")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: min(geo.size.height * 0.48, 580))
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized(existingEvent == nil ? "create_event.nav_title" : "create_event.nav_title_edit"),
                        backButtonImageName: "CreateEventNavBack",
                        titleLetterSpacing: -0.6
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            dateField
                            locationField
                            eventNameField
                            descriptionField
                            timeField
                            teamField
                            EventCreateCoverPhotoBlock(viewModel: viewModel, photoPickerItem: $coverPhotoPickerItem)
                            submitButton
                        }
                        .frame(maxWidth: 350)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 48)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
    }

    private var dateField: some View {
        figmaLabeledField(titleKey: "create_event.field.date_short") {
            HStack(spacing: 0) {
                Image("CreateEventFieldCalendar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding(.leading, 8)
                    .padding(.trailing, 4)

                Spacer(minLength: 0)

                DatePicker("", selection: $viewModel.eventDay, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(ColorPalette.leagueSegmentFill)

                Spacer(minLength: 0)
            }
            .padding(.vertical, 15)
            .padding(.trailing, 16)
        }
    }

    private var locationField: some View {
        figmaLabeledField(titleKey: "create_event.field.location") {
            HStack(spacing: 12) {
                Image("CreateEventFieldLocation")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                TextField("", text: $viewModel.location, prompt: Text(loc.localized("create_event.placeholder.location"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.textMuted))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.autoNameToneHint)
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 17)
        }
    }

    private var eventNameField: some View {
        figmaLabeledField(titleKey: "create_event.field.name") {
            HStack(spacing: 12) {
                Image("CreateEventFieldEventName")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                TextField("", text: $viewModel.eventName, prompt: Text(loc.localized("create_event.placeholder.name"))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.textMuted))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.autoNameToneHint)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 15)
        }
    }

    private var descriptionField: some View {
        figmaLabeledField(titleKey: "create_event.field.description") {
            ZStack(alignment: .topLeading) {
                if viewModel.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(loc.localized("create_event.placeholder.description_body"))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorPalette.textMuted)
                        .padding(.top, 2)
                }
                TextEditor(text: $viewModel.notes)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.autoNameToneHint)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
    }

    private var timeField: some View {
        figmaLabeledField(titleKey: "create_event.field.time") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(loc.localized("create_event.time.start"))
                            .font(.system(size: 12, weight: .bold))
                            .tracking(0.6)
                            .foregroundColor(ColorPalette.createEventTimeRowLabel)
                        timePickerCompact(selection: $viewModel.startTime)
                    }
                    .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(loc.localized("create_event.time.end"))
                            .font(.system(size: 12, weight: .bold))
                            .tracking(0.6)
                            .foregroundColor(ColorPalette.createEventTimeRowLabel)
                        timePickerCompact(selection: $viewModel.endTime)
                    }
                    .frame(maxWidth: .infinity)
                }

                durationBadge
            }
            .padding(16)
        }
    }

    private func timePickerCompact(selection: Binding<Date>) -> some View {
        DatePicker("", selection: selection, displayedComponents: .hourAndMinute)
            .labelsHidden()
            .datePickerStyle(.compact)
            .tint(ColorPalette.leagueSegmentFill)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var teamField: some View {
        figmaLabeledField(titleKey: "create_event.field.team") {
            Group {
                if viewModel.teams.isEmpty {
                    Text(loc.localized("create_event.no_teams"))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(ColorPalette.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                } else {
                    VStack(spacing: 10) {
                        ForEach(viewModel.teams) { team in
                            teamOptionRow(team: team)
                        }
                    }
                }
            }
            .padding(16)
        }
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
            Text(durationValueText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorPalette.createEventDurationValue)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(ColorPalette.background)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ColorPalette.createEventFormFieldStroke, lineWidth: 1)
        )
    }

    private var durationValueText: String {
        guard let s = viewModel.mergedStartDateTime, let e = viewModel.mergedEndDateTime, e > s else {
            return loc.localized("create_event.duration.placeholder")
        }
        let minutes = Int(e.timeIntervalSince(s) / 60)
        let h = minutes / 60
        let m = minutes % 60
        return String(format: loc.localized("create_event.duration.format"), h, m)
    }

    private func teamOptionRow(team: Team) -> some View {
        let selected = viewModel.selectedTeamId == team.id
        return Button {
            viewModel.selectedTeamId = team.id
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(selected ? ColorPalette.createEventTeamRowSelectedStroke : ColorPalette.createEventFormFieldStroke, lineWidth: 1)
                        .frame(width: 20, height: 20)
                    if selected {
                        Circle()
                            .fill(ColorPalette.createEventTeamRadioInnerFill)
                            .frame(width: 10, height: 10)
                    }
                }

                TeamLogoThumb(team: team)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(ColorPalette.createEventFormFieldStroke, lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(team.name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(ColorPalette.autoNameSectionLabel)
                    Text(String(format: loc.localized("create_event.team.meta_format"), team.players.count, loc.localized("create_event.team.active")))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(selected ? ColorPalette.createEventDurationValue : ColorPalette.createEventTeamSubtitleMuted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background {
                if selected {
                    LinearGradient(
                        colors: [
                            ColorPalette.createEventTeamRowSelectedFillStart,
                            ColorPalette.createEventTeamRowSelectedFillEnd
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    ColorPalette.background
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        selected ? ColorPalette.createEventTeamRowSelectedStroke : ColorPalette.createEventFormFieldStroke,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var submitButton: some View {
        Button {
            guard let event = viewModel.makeEvent() else { return }
            onSave(event)
            dismiss()
        } label: {
            HStack(spacing: 8) {
                if existingEvent == nil {
                    Image("CreateEventSubmitPlus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                Text(loc.localized(existingEvent == nil ? "events.create_button" : "create_event.submit_save"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(ColorPalette.navigationBarLinearGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: ColorPalette.createEventNavDropShadow.opacity(0.55), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.canSubmit)
        .opacity(viewModel.canSubmit ? 1 : 0.45)
    }

    private func figmaLabeledField<Content: View>(titleKey: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(loc.localized(titleKey))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.autoNameSectionLabel)

            content()
                .background(ColorPalette.background)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(ColorPalette.createEventFormFieldStroke, lineWidth: 1)
                )
                .shadow(color: ColorPalette.createEventFormFieldShadow, radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    CreateEventView(teams: [Team.previewLakeWalkers], initialDay: Date()) { _ in }
        .environmentObject(LocalizationService.shared)
}
