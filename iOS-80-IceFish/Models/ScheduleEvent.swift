import Foundation

struct ScheduleEvent: Identifiable, Equatable, Codable {
    let id: UUID
    let title: String
    let startDateTime: Date
    let endDateTime: Date
    let location: String
    let notes: String
    let teamId: UUID?
}
