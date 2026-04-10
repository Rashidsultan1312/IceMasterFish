import Combine
import Foundation

/// Builds list rows for the Events tab from schedule data only; it does not persist.
/// Source of truth: `ScheduleTabViewModel` ↔ `UserDefaultsScheduleStorage` (`ScheduleEvent` JSON).
@MainActor
final class EventsTabViewModel: ObservableObject {
    @Published private(set) var items: [EventsTabDisplayItem] = []

    private var calendar: Calendar

    init(calendar: Calendar = .current, items: [EventsTabDisplayItem] = []) {
        var cal = calendar
        cal.firstWeekday = 1
        self.calendar = cal
        self.items = items
    }

    func update(from events: [ScheduleEvent], teams: [Team], now: Date = Date()) {
        items = Self.buildItems(events: events, teams: teams, calendar: calendar, now: now)
    }

    static func buildItems(
        events: [ScheduleEvent],
        teams: [Team],
        calendar: Calendar,
        now: Date
    ) -> [EventsTabDisplayItem] {
        let sorted = events.sorted { $0.startDateTime < $1.startDateTime }
        let teamById = Dictionary(uniqueKeysWithValues: teams.map { ($0.id, $0) })

        return mapSortedEvents(sorted, teamById: teamById, calendar: calendar, now: now)
    }

    /// Resolves list badges (`featured`, `upcoming`) using the full event list order.
    static func displayItem(
        for event: ScheduleEvent,
        allEvents: [ScheduleEvent],
        teams: [Team],
        calendar: Calendar = .current,
        now: Date = Date()
    ) -> EventsTabDisplayItem {
        var cal = calendar
        cal.firstWeekday = 1
        let sorted = allEvents.sorted { $0.startDateTime < $1.startDateTime }
        let teamById = Dictionary(uniqueKeysWithValues: teams.map { ($0.id, $0) })
        let items = mapSortedEvents(sorted, teamById: teamById, calendar: cal, now: now)
        return items.first { $0.id == event.id }
            ?? mapSortedEvents([event], teamById: teamById, calendar: cal, now: now)[0]
    }

    private static func mapSortedEvents(
        _ sorted: [ScheduleEvent],
        teamById: [UUID: Team],
        calendar: Calendar,
        now: Date
    ) -> [EventsTabDisplayItem] {
        sorted.enumerated().map { index, event in
            let upcoming = event.endDateTime >= now
            let featured = index == 0

            let secondary: EventsTabSecondaryLine
            if let tid = event.teamId, let team = teamById[tid] {
                secondary = .members(count: team.players.count)
            } else {
                let loc = event.location.trimmingCharacters(in: .whitespacesAndNewlines)
                secondary = .location(loc)
            }

            return EventsTabDisplayItem(
                id: event.id,
                title: event.title,
                body: event.notes.trimmingCharacters(in: .whitespacesAndNewlines),
                startDate: event.startDateTime,
                secondaryLine: secondary,
                showFeaturedBadge: featured,
                showUpcomingBadge: upcoming,
                listIndex: index
            )
        }
    }
}

extension EventsTabViewModel {
    static var previewEmpty: EventsTabViewModel {
        EventsTabViewModel(items: [])
    }
}
