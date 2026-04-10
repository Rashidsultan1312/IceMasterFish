import SwiftUI

/// Events tab lists `ScheduleEvent` data (same as Schedule); persistence is `UserDefaultsScheduleStorage`.
struct EventsTabView: View {
    @EnvironmentObject private var loc: LocalizationService
    @ObservedObject var viewModel: EventsTabViewModel
    @ObservedObject var scheduleViewModel: ScheduleTabViewModel
    let teams: [Team]

    @State private var showCreateEvent = false
    @State private var detailScheduledEventId: EventsScheduledDetailIdentifier?
    @State private var detailDefaultItem: EventsTabDisplayItem?
    @State private var createEventDraft: ScheduleEvent?
    @State private var pendingEditorDraft: ScheduleEvent?

    private var defaultContentItems: [EventsTabDisplayItem] {
        [
            EventsTabDisplayItem(
                id: UUID(uuidString: "11B14CB8-64D7-4E41-B06D-E3B8789A1A01")!,
                title: loc.localized("events.default.wifc.title"),
                body: loc.localized("events.default.wifc.body"),
                startDate: date(year: 2026, month: 7, day: 10),
                secondaryLine: .location(loc.localized("events.default.wifc.location")),
                showFeaturedBadge: true,
                showUpcomingBadge: true,
                listIndex: 0
            ),
            EventsTabDisplayItem(
                id: UUID(uuidString: "E8D3EA2A-6E90-4C80-96EE-0E71694D6302")!,
                title: loc.localized("events.default.sweden.title"),
                body: loc.localized("events.default.sweden.body"),
                startDate: date(year: 2026, month: 7, day: 24),
                secondaryLine: .location(loc.localized("events.default.sweden.location")),
                showFeaturedBadge: false,
                showUpcomingBadge: true,
                listIndex: 1
            ),
            EventsTabDisplayItem(
                id: UUID(uuidString: "9205B815-F4F4-4898-B2AA-090C9705A4A3")!,
                title: loc.localized("events.default.estonia.title"),
                body: loc.localized("events.default.estonia.body"),
                startDate: date(year: 2026, month: 8, day: 5),
                secondaryLine: .location(loc.localized("events.default.estonia.location")),
                showFeaturedBadge: false,
                showUpcomingBadge: true,
                listIndex: 2
            ),
        ]
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                allEventsSection
                createEventButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 120)
        }
        .background(AppScreenBackgroundView())
        .onAppear {
            viewModel.update(from: scheduleViewModel.events, teams: teams)
        }
        .onChange(of: scheduleViewModel.events) { newEvents in
            viewModel.update(from: newEvents, teams: teams)
        }
        .onChange(of: teams) { newTeams in
            viewModel.update(from: scheduleViewModel.events, teams: newTeams)
        }
        .fullScreenCover(isPresented: $showCreateEvent, onDismiss: {
            createEventDraft = nil
        }) {
            Group {
                if let draft = createEventDraft {
                    CreateEventView(
                        teams: teams,
                        initialDay: Calendar.current.startOfDay(for: draft.startDateTime),
                        existingEvent: draft
                    ) { event in
                        scheduleViewModel.upsertEvent(event)
                        createEventDraft = nil
                    }
                    .id(draft.id.uuidString)
                } else {
                    EventsCreateEventView(
                        teams: teams,
                        initialDay: Date()
                    ) { event in
                        scheduleViewModel.upsertEvent(event)
                    }
                    .id("new")
                }
            }
            .environmentObject(loc)
        }
        .fullScreenCover(item: $detailScheduledEventId) { identifier in
            EventsEventDetailView(
                scheduleViewModel: scheduleViewModel,
                eventId: identifier.id,
                teams: teams,
                onEdit: {
                    guard let event = scheduleViewModel.events.first(where: { $0.id == identifier.id }) else { return }
                    pendingEditorDraft = event
                    detailScheduledEventId = nil
                },
                onDelete: {
                    scheduleViewModel.removeEvent(id: identifier.id)
                    detailScheduledEventId = nil
                }
            )
            .environmentObject(loc)
        }
        .fullScreenCover(item: $detailDefaultItem) { item in
            EventsEventDetailView(
                scheduleViewModel: scheduleViewModel,
                teams: teams,
                templateItem: item
            )
            .environmentObject(loc)
        }
        .onChange(of: detailScheduledEventId) { newValue in
            guard newValue == nil, let draft = pendingEditorDraft else { return }
            pendingEditorDraft = nil
            createEventDraft = draft
            DispatchQueue.main.async {
                showCreateEvent = true
            }
        }
    }

    private var allEventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    ColorPalette.eventsSectionIconGradientTop,
                                    ColorPalette.eventsSectionIconGradientBottom
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                    Image("EventsSectionAllIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }

                Text(loc.localized("events.section.all"))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
            }

            VStack(spacing: 16) {
                ForEach(defaultContentItems) { item in
                    EventsEventCardView(item: item) {
                        detailDefaultItem = item
                    }
                }
                ForEach(viewModel.items) { item in
                    EventsEventCardView(item: item) {
                        detailScheduledEventId = EventsScheduledDetailIdentifier(id: item.id)
                    }
                }
            }
        }
    }

    private var emptyEventsCard: some View {
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
                .offset(x: 200, y: 4)
                .allowsHitTesting(false)

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
                .offset(x: -20, y: 140)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Image("EventsEmptyIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 220)
                    .padding(.bottom, 16)

                Text(loc.localized("events.empty.title"))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ColorPalette.autoNameSectionLabel)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)

                Text(loc.localized("events.empty.message"))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(ColorPalette.eventsEmptyBodyText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 12)
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
                Image("EventsCreatePlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(loc.localized("events.create_button"))
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

    private func date(year: Int, month: Int, day: Int) -> Date {
        let cal = Calendar.current
        return cal.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
}

private struct EventsScheduledDetailIdentifier: Identifiable, Hashable {
    let id: UUID
}

#Preview("Empty") {
    EventsTabView(
        viewModel: .previewEmpty,
        scheduleViewModel: .previewEmpty,
        teams: []
    )
    .environmentObject(LocalizationService.shared)
}

#Preview("List") {
    let feed = ScheduleTabViewModel.previewEventsFeed()
    EventsTabView(
        viewModel: EventsTabViewModel(),
        scheduleViewModel: feed.schedule,
        teams: feed.teams
    )
    .environmentObject(LocalizationService.shared)
}
