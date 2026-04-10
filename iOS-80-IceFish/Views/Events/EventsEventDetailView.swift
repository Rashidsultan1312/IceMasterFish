import SwiftUI

struct EventsEventDetailView: View {
    @EnvironmentObject private var loc: LocalizationService
    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var scheduleViewModel: ScheduleTabViewModel
    private let eventId: UUID?
    private let teams: [Team]
    private let templateDisplayItem: EventsTabDisplayItem?
    private let showsManagementActions: Bool
    private let onEdit: () -> Void
    private let onDelete: () -> Void

    @State private var confirmDelete = false

    /// Detail for a persisted `ScheduleEvent`; `displayItem` is derived so edits elsewhere refresh the card.
    init(
        scheduleViewModel: ScheduleTabViewModel,
        eventId: UUID,
        teams: [Team],
        onEdit: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        _scheduleViewModel = ObservedObject(wrappedValue: scheduleViewModel)
        self.eventId = eventId
        self.teams = teams
        templateDisplayItem = nil
        showsManagementActions = true
        self.onEdit = onEdit
        self.onDelete = onDelete
    }

    init(scheduleViewModel: ScheduleTabViewModel, teams: [Team], templateItem: EventsTabDisplayItem) {
        _scheduleViewModel = ObservedObject(wrappedValue: scheduleViewModel)
        eventId = nil
        self.teams = teams
        templateDisplayItem = templateItem
        showsManagementActions = false
        onEdit = {}
        onDelete = {}
    }

    private var resolvedDisplayItem: EventsTabDisplayItem? {
        if let eventId {
            guard let event = scheduleViewModel.events.first(where: { $0.id == eventId }) else { return nil }
            return EventsTabViewModel.displayItem(
                for: event,
                allEvents: scheduleViewModel.events,
                teams: teams
            )
        }
        return templateDisplayItem
    }

    private var mainContentGradient: LinearGradient {
        LinearGradient(
            colors: [ColorPalette.mainBackgroundTop, ColorPalette.mainBackgroundBottom],
            startPoint: .top,
            endPoint: .bottom
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

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                mainContentGradient
                    .ignoresSafeArea()

                Image("EventsDetailBodyDecor")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: min(geo.size.height * 0.55, 700))
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized("events.detail.nav_title"),
                        backButtonImageName: "CreateEventNavBack",
                        titleLetterSpacing: -0.6
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 32) {
                            if let item = resolvedDisplayItem {
                                EventsEventCardView(
                                    item: item,
                                    showsHeroChevron: false,
                                    isDetailPresentation: true,
                                    onTap: nil
                                )
                                if showsManagementActions {
                                    editButton
                                    deleteButton
                                }
                            } else {
                                Text(loc.localized("events.detail.event_unavailable"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(ColorPalette.textMuted)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 24)
                            }
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
        .onChange(of: scheduleViewModel.events) { _ in
            guard let eventId else { return }
            if !scheduleViewModel.events.contains(where: { $0.id == eventId }) {
                dismiss()
            }
        }
        .alert(loc.localized("schedule.detail.delete_confirm_title"), isPresented: $confirmDelete) {
            Button(loc.localized("schedule.detail.delete_cancel"), role: .cancel) {}
            Button(loc.localized("schedule.detail.delete_confirm"), role: .destructive) {
                onDelete()
            }
        } message: {
            Text(loc.localized("schedule.detail.delete_confirm_message"))
        }
    }

    private var editButton: some View {
        Button(action: onEdit) {
            Text(loc.localized("events.detail.edit"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(ColorPalette.navigationBarLinearGradient)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: ColorPalette.createEventNavDropShadow.opacity(0.55), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    private var deleteButton: some View {
        Button {
            confirmDelete = true
        } label: {
            Text(loc.localized("events.detail.delete"))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorPalette.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(deleteGradient)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: ColorPalette.deleteButtonGradientMid.opacity(0.35), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let feed = ScheduleTabViewModel.previewEventsFeed()
    let event = feed.schedule.events[0]
    EventsEventDetailView(
        scheduleViewModel: feed.schedule,
        eventId: event.id,
        teams: feed.teams,
        onEdit: {},
        onDelete: {}
    )
    .environmentObject(LocalizationService.shared)
}
