import PhotosUI
import SwiftUI

struct EventsCreateEventView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var loc: LocalizationService
    @StateObject private var viewModel: CreateEventViewModel
    @State private var coverPhotoPickerItem: PhotosPickerItem?

    var onSave: (ScheduleEvent) -> Void

    init(teams: [Team], initialDay: Date, onSave: @escaping (ScheduleEvent) -> Void) {
        _viewModel = StateObject(wrappedValue: CreateEventViewModel(teams: teams, initialDay: initialDay, existingEvent: nil))
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

                Image("EventsCreateV2BodyDecor")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: min(geo.size.height * 0.50, 582))
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized("create_event.nav_title"),
                        backButtonImageName: "EventsCreateV2NavBack",
                        titleLetterSpacing: -0.6
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            dateField
                            locationField
                            eventNameField
                            descriptionField
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
                Image("EventsCreateV2FieldCalendar")
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
                    .foregroundStyle(ColorPalette.autoNameToneHint)

                Spacer(minLength: 0)
            }
            .padding(.vertical, 15)
            .padding(.trailing, 16)
        }
    }

    private var locationField: some View {
        figmaLabeledField(titleKey: "create_event.field.location") {
            HStack(spacing: 12) {
                Image("EventsCreateV2FieldLocation")
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
                Image("EventsCreateV2FieldEventName")
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
                        .lineSpacing(4)
                        .padding(.top, 2)
                }
                TextEditor(text: $viewModel.notes)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ColorPalette.autoNameToneHint)
                    .scrollContentBackground(.hidden)
                    .lineSpacing(4)
                    .frame(minHeight: 120)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
    }

    private var submitButton: some View {
        Button {
            guard let event = viewModel.makeEvent() else { return }
            onSave(event)
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image("EventsCreateV2SubmitPlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(loc.localized("schedule.create_event"))
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
    EventsCreateEventView(teams: [Team.previewLakeWalkers], initialDay: Date()) { _ in }
        .environmentObject(LocalizationService.shared)
}
