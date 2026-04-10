import Combine
import Foundation

@MainActor
final class ScheduleTabViewModel: ObservableObject {
    @Published private(set) var displayedMonthStart: Date
    @Published var selectedDate: Date
    @Published private(set) var events: [ScheduleEvent]

    private var calendar: Calendar
    private let storage: any ScheduleStorageProtocol

    init(
        calendar: Calendar = .current,
        displayedMonthStart: Date? = nil,
        selectedDate: Date? = nil,
        events: [ScheduleEvent]? = nil,
        storage: any ScheduleStorageProtocol = UserDefaultsScheduleStorage.shared
    ) {
        var cal = calendar
        cal.firstWeekday = 1
        self.calendar = cal
        self.storage = storage

        let now = Date()
        let startOfThisMonth = cal.date(from: cal.dateComponents([.year, .month], from: now)) ?? now

        self.displayedMonthStart = displayedMonthStart ?? startOfThisMonth
        self.selectedDate = selectedDate ?? now
        self.events = events ?? storage.load()
    }

    var hasAnyEvents: Bool {
        !events.isEmpty
    }

    func events(on day: Date) -> [ScheduleEvent] {
        events.filter { calendar.isDate($0.startDateTime, inSameDayAs: day) }
            .sorted { $0.startDateTime < $1.startDateTime }
    }

    func hasEvent(on day: Date) -> Bool {
        events.contains { calendar.isDate($0.startDateTime, inSameDayAs: day) }
    }

    func upsertEvent(_ event: ScheduleEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
        } else {
            events.append(event)
        }
        selectedDate = calendar.startOfDay(for: event.startDateTime)
        if let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: event.startDateTime)) {
            displayedMonthStart = monthStart
        }
        persist()
    }

    func removeEvent(id: UUID) {
        events.removeAll { $0.id == id }
        EventCoverImageStorage.removeImage(eventId: id)
        persist()
    }

    func isSelected(_ day: Date) -> Bool {
        calendar.isDate(day, inSameDayAs: selectedDate)
    }

    func monthGrid() -> [ScheduleDayCellModel] {
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonthStart)) ?? displayedMonthStart
        let weekday = calendar.component(.weekday, from: monthStart)
        let leading = (weekday - calendar.firstWeekday + 7) % 7
        let startGrid = calendar.date(byAdding: .day, value: -leading, to: monthStart) ?? monthStart

        return (0..<42).compactMap { offset -> ScheduleDayCellModel? in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startGrid) else { return nil }
            let day = calendar.component(.day, from: date)
            let inMonth = calendar.isDate(date, equalTo: displayedMonthStart, toGranularity: .month)
            return ScheduleDayCellModel(
                id: offset,
                dayNumber: day,
                isWithinDisplayedMonth: inMonth,
                date: date,
                hasEvent: hasEvent(on: date)
            )
        }
    }

    func goToPreviousMonth() {
        guard let d = calendar.date(byAdding: .month, value: -1, to: displayedMonthStart) else { return }
        displayedMonthStart = d
        clampSelectionToDisplayedMonthIfNeeded()
    }

    func goToNextMonth() {
        guard let d = calendar.date(byAdding: .month, value: 1, to: displayedMonthStart) else { return }
        displayedMonthStart = d
        clampSelectionToDisplayedMonthIfNeeded()
    }

    func selectDay(_ date: Date) {
        selectedDate = date
        if !calendar.isDate(date, equalTo: displayedMonthStart, toGranularity: .month) {
            if let newMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) {
                displayedMonthStart = newMonth
            }
        }
    }

    private func clampSelectionToDisplayedMonthIfNeeded() {
        if calendar.isDate(selectedDate, equalTo: displayedMonthStart, toGranularity: .month) { return }
        selectedDate = displayedMonthStart
    }

    private func persist() {
        storage.save(events)
    }
}

extension ScheduleTabViewModel {
    static var previewEmpty: ScheduleTabViewModel {
        var cal = Calendar.current
        cal.firstWeekday = 1
        let feb = cal.date(from: DateComponents(year: 2025, month: 2, day: 1))!
        let day14 = cal.date(from: DateComponents(year: 2025, month: 2, day: 14))!
        return ScheduleTabViewModel(
            calendar: cal,
            displayedMonthStart: feb,
            selectedDate: day14,
            events: []
        )
    }

    static var previewWithSampleEvents: ScheduleTabViewModel {
        var cal = Calendar.current
        cal.firstWeekday = 1
        let feb = cal.date(from: DateComponents(year: 2025, month: 2, day: 1))!
        let day14 = cal.date(from: DateComponents(year: 2025, month: 2, day: 14))!

        func day(_ d: Int) -> Date {
            cal.date(from: DateComponents(year: 2025, month: 2, day: d))!
        }

        let start = cal.date(bySettingHour: 9, minute: 0, second: 0, of: day14) ?? day14
        let end = cal.date(bySettingHour: 13, minute: 0, second: 0, of: day14) ?? day14
        let sample = ScheduleEvent(
            id: UUID(),
            title: "Trophy Catch Session",
            startDateTime: start,
            endDateTime: end,
            location: "Lake Michigan, North Pier",
            notes: "",
            teamId: nil
        )

        return ScheduleTabViewModel(
            calendar: cal,
            displayedMonthStart: feb,
            selectedDate: day14,
            events: [sample]
        )
    }

    /// Schedule + teams for SwiftUI previews of the Events tab list.
    static func previewEventsFeed() -> (schedule: ScheduleTabViewModel, teams: [Team]) {
        var cal = Calendar.current
        cal.firstWeekday = 1
        let teamId = UUID()
        let players = (0..<12).map { index in
            RosterPlayerDraft(
                name: "Member \(index + 1)",
                isCaptain: index == 0,
                useFilledAvatar: index.isMultiple(of: 2)
            )
        }
        let team = Team(
            id: teamId,
            name: "Ice Crew",
            leagueType: .amateur,
            presetIndex: 0,
            customLogoData: nil,
            players: players,
            additionalInfo: ""
        )
        let feb15 = cal.date(from: DateComponents(year: 2025, month: 2, day: 15, hour: 9, minute: 0))!
        let feb15End = cal.date(from: DateComponents(year: 2025, month: 2, day: 15, hour: 13, minute: 0))!
        let jan28 = cal.date(from: DateComponents(year: 2025, month: 1, day: 28, hour: 10, minute: 0))!
        let jan28End = cal.date(from: DateComponents(year: 2025, month: 1, day: 28, hour: 12, minute: 0))!
        let e1 = ScheduleEvent(
            id: UUID(),
            title: "Winter Pike Challenge",
            startDateTime: feb15,
            endDateTime: feb15End,
            location: "Lake Baikal",
            notes: "Join us for an exciting day on the ice. Prizes for the biggest catch and best team spirit.",
            teamId: nil
        )
        let e2 = ScheduleEvent(
            id: UUID(),
            title: "Team Drill & Gear Check",
            startDateTime: jan28,
            endDateTime: jan28End,
            location: "",
            notes: "Short safety briefing, hole drilling practice, and gear inspection before the season peak.",
            teamId: teamId
        )
        let vm = ScheduleTabViewModel(calendar: cal, events: [e1, e2])
        return (vm, [team])
    }
}
