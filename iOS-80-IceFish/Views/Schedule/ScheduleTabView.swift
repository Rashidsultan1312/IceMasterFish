import SwiftUI

struct ScheduleTabView: View {
    @EnvironmentObject private var loc: LocalizationService
    @ObservedObject var viewModel: ScheduleTabViewModel
    let teams: [Team]

    @State private var showCreateEvent = false
    @State private var detailEvent: ScheduleEvent?
    @State private var createEventDraft: ScheduleEvent?
    @State private var pendingEditorDraft: ScheduleEvent?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    private var mainContentGradient: LinearGradient {
        LinearGradient(
            colors: [ColorPalette.mainBackgroundTop, ColorPalette.mainBackgroundBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var selectedDayGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.scheduleSelectedDayGradientStart,
                ColorPalette.scheduleSelectedDayGradientEnd
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var emptyIconInnerGradient: LinearGradient {
        LinearGradient(
            colors: [
                ColorPalette.teamCardGradientBlob,
                ColorPalette.cardBorder.opacity(0.95)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                calendarCard
                secondarySection
                createEventButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 120)
        }
        .background(AppScreenBackgroundView())
        .fullScreenCover(isPresented: $showCreateEvent, onDismiss: {
            createEventDraft = nil
        }) {
            CreateEventView(
                teams: teams,
                initialDay: createEventDraft.map { Calendar.current.startOfDay(for: $0.startDateTime) } ?? viewModel.selectedDate,
                existingEvent: createEventDraft
            ) { event in
                viewModel.upsertEvent(event)
                createEventDraft = nil
            }
            .id(createEventDraft?.id.uuidString ?? "new")
            .environmentObject(loc)
        }
        .fullScreenCover(item: $detailEvent) { event in
            ScheduleEventDetailView(
                event: event,
                teams: teams,
                onEdit: {
                    pendingEditorDraft = event
                    detailEvent = nil
                },
                onDelete: {
                    viewModel.removeEvent(id: event.id)
                    detailEvent = nil
                }
            )
            .environmentObject(loc)
        }
        .onChange(of: detailEvent) { newValue in
            guard newValue == nil, let draft = pendingEditorDraft else { return }
            pendingEditorDraft = nil
            createEventDraft = draft
            showCreateEvent = true
        }
    }

    private var calendarCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(ColorPalette.background)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(monthYearString(for: viewModel.displayedMonthStart))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(ColorPalette.autoNameSectionLabel)

                    Spacer()

                    HStack(spacing: 8) {
                        monthNavButton(imageName: "ScheduleCalPrevBtn", action: viewModel.goToPreviousMonth)
                        monthNavButton(imageName: "ScheduleCalNextBtn", action: viewModel.goToNextMonth)
                    }
                }
                .padding(.bottom, 16)

                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(weekdayHeaders, id: \.self) { symbol in
                        Text(symbol)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(ColorPalette.scheduleWeekdayLabel)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                }

                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(viewModel.monthGrid()) { cell in
                        dayCell(cell)
                    }
                }
            }
            .padding(20)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private func monthNavButton(imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }

    private func dayCell(_ cell: ScheduleDayCellModel) -> some View {
        let selected = viewModel.isSelected(cell.date)
        return Button {
            viewModel.selectDay(cell.date)
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if selected {
                        Circle()
                            .fill(selectedDayGradient)
                            .frame(width: 40, height: 40)
                            .shadow(color: ColorPalette.shadowBlue.opacity(0.35), radius: 6, x: 0, y: 3)
                    }
                    Text("\(cell.dayNumber)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(dayNumberColor(cell: cell, selected: selected))
                }
                .frame(height: 40)

                Circle()
                    .fill(cell.hasEvent ? ColorPalette.scheduleEventDayDot : Color.clear)
                    .frame(width: 6, height: 6)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func dayNumberColor(cell: ScheduleDayCellModel, selected: Bool) -> Color {
        if selected { return ColorPalette.background }
        return cell.isWithinDisplayedMonth
            ? ColorPalette.scheduleCalendarDayPrimary
            : ColorPalette.scheduleCalendarDayMuted
    }

    private var secondarySection: some View {
        Group {
            if viewModel.hasAnyEvents {
                eventsForSelectedDateSection
            } else {
                emptyStateCard
            }
        }
    }

    private var eventsForSelectedDateSection: some View {
        let items = viewModel.events(on: viewModel.selectedDate)
        return VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image("ScheduleSectionEventsIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text(eventsOnTitle(for: viewModel.selectedDate))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            if items.isEmpty {
                Text(loc.localized("schedule.day_empty.message"))
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(ColorPalette.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 16) {
                    ForEach(items) { event in
                        Button {
                            detailEvent = event
                        } label: {
                            ScheduleEventCardView(event: event)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var emptyStateCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(ColorPalette.background)

            RoundedRectangle(cornerRadius: 999, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            ColorPalette.mainBackgroundTop.opacity(0.9),
                            ColorPalette.background
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 96, height: 96)
                .opacity(0.5)
                .offset(x: -24, y: 120)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .stroke(
                            ColorPalette.scheduleEmptyIconRingStroke,
                            style: StrokeStyle(lineWidth: 2, dash: [6, 4])
                        )
                        .frame(width: 96, height: 96)

                    Circle()
                        .fill(emptyIconInnerGradient)
                        .frame(width: 64, height: 64)

                    Image("ScheduleEmptyCalIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .padding(.bottom, 20)

                Text(loc.localized("schedule.empty.title"))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)

                Text(loc.localized("schedule.empty.message"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(ColorPalette.scheduleEmptyBodyText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 28)
            .padding(.horizontal, 16)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    private var createEventButton: some View {
        Button {
            createEventDraft = nil
            showCreateEvent = true
        } label: {
            HStack(spacing: 8) {
                Image("ScheduleCreatePlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(loc.localized("schedule.create_event"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.background)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [
                        ColorPalette.navigationBarGradientStart,
                        ColorPalette.navigationBarGradientMid,
                        ColorPalette.navigationBarGradientEnd
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: ColorPalette.shadowBlue.opacity(0.45), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    private var weekdayHeaders: [String] {
        var cal = Calendar.current
        cal.firstWeekday = 1
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.calendar = cal
        return df.shortWeekdaySymbols.map { String($0.prefix(1)).uppercased() }
    }

    private func monthYearString(for date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return df.string(from: date)
    }

    private func eventsOnTitle(for date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.setLocalizedDateFormatFromTemplate("MMM d")
        return String(format: loc.localized("schedule.events_on_format"), df.string(from: date))
    }
}

#Preview("Empty") {
    ScheduleTabView(viewModel: .previewEmpty, teams: [])
        .environmentObject(LocalizationService.shared)
}

#Preview("With events") {
    ScheduleTabView(viewModel: .previewWithSampleEvents, teams: [Team.previewLakeWalkers])
        .environmentObject(LocalizationService.shared)
}
