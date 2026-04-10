import Foundation

struct ScheduleDayCellModel: Identifiable, Equatable {
    let id: Int
    let dayNumber: Int
    let isWithinDisplayedMonth: Bool
    let date: Date
    let hasEvent: Bool
}
