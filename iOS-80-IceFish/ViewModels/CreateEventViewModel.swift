import Combine
import Foundation
import UIKit

@MainActor
final class CreateEventViewModel: ObservableObject {
    @Published var eventName: String = ""
    @Published var eventDay: Date
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var location: String = ""
    @Published var notes: String = ""
    @Published var selectedTeamId: UUID?

    /// Compressed JPEG data from the library, or `nil` if the user has not picked a new image.
    @Published private(set) var pickedCoverImageJPEGData: Data?
    /// When `true`, any existing file for this event id is removed on save.
    @Published private(set) var userRemovedCover: Bool = false

    let teams: [Team]

    private var calendar: Calendar
    private let existingEventId: UUID?

    init(teams: [Team], initialDay: Date, existingEvent: ScheduleEvent? = nil, calendar: Calendar = .current) {
        self.teams = teams
        var cal = calendar
        cal.firstWeekday = 1
        self.calendar = cal

        if let existing = existingEvent {
            self.existingEventId = existing.id
            let dayStart = cal.startOfDay(for: existing.startDateTime)
            self.eventDay = dayStart
            self.startTime = existing.startDateTime
            self.endTime = existing.endDateTime
            self.eventName = existing.title
            self.location = existing.location
            self.notes = existing.notes
            self.selectedTeamId = existing.teamId ?? teams.first?.id
        } else {
            self.existingEventId = nil
            let dayStart = cal.startOfDay(for: initialDay)
            self.eventDay = dayStart
            let start = cal.date(bySettingHour: 9, minute: 0, second: 0, of: dayStart) ?? dayStart
            let end = cal.date(bySettingHour: 13, minute: 0, second: 0, of: dayStart) ?? dayStart
            self.startTime = start
            self.endTime = end
            self.selectedTeamId = teams.first?.id
        }
    }

    var coverPreviewUIImage: UIImage? {
        if userRemovedCover { return nil }
        if let data = pickedCoverImageJPEGData, let image = UIImage(data: data) { return image }
        if let id = existingEventId, let image = EventCoverImageStorage.loadImage(eventId: id) { return image }
        return nil
    }

    func applyPickedCoverImage(data: Data) {
        guard let ui = UIImage(data: data), let jpeg = ui.jpegData(compressionQuality: 0.88) else { return }
        pickedCoverImageJPEGData = jpeg
        userRemovedCover = false
    }

    func clearCoverImage() {
        pickedCoverImageJPEGData = nil
        userRemovedCover = true
    }

    var mergedStartDateTime: Date? {
        merge(day: eventDay, time: startTime)
    }

    var mergedEndDateTime: Date? {
        merge(day: eventDay, time: endTime)
    }

    var canSubmit: Bool {
        let name = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return false }
        guard let s = mergedStartDateTime, let e = mergedEndDateTime, e > s else { return false }
        return true
    }

    func makeEvent() -> ScheduleEvent? {
        guard canSubmit else { return nil }
        let name = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let s = mergedStartDateTime, let e = mergedEndDateTime else { return nil }
        let id = existingEventId ?? UUID()

        if userRemovedCover {
            EventCoverImageStorage.removeImage(eventId: id)
        } else if let jpeg = pickedCoverImageJPEGData {
            try? EventCoverImageStorage.saveJPEG(jpeg, eventId: id)
        }

        return ScheduleEvent(
            id: id,
            title: name,
            startDateTime: s,
            endDateTime: e,
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines),
            teamId: selectedTeamId
        )
    }

    private func merge(day: Date, time: Date) -> Date? {
        let d = calendar.dateComponents([.year, .month, .day], from: day)
        let t = calendar.dateComponents([.hour, .minute], from: time)
        var merged = DateComponents()
        merged.year = d.year
        merged.month = d.month
        merged.day = d.day
        merged.hour = t.hour
        merged.minute = t.minute
        return calendar.date(from: merged)
    }
}
