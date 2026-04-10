import Foundation
import UIKit

/// On-disk JPEG covers for schedule events: `Documents/EventCoverImages/{eventId}.jpg` (no `ScheduleEvent` field; works with existing JSON).
enum EventCoverImageStorage {
    private static var folderURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("EventCoverImages", isDirectory: true)
    }

    private static func ensureFolder() {
        try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
    }

    private static func fileURL(eventId: UUID) -> URL {
        folderURL.appendingPathComponent("\(eventId.uuidString).jpg")
    }

    static func saveJPEG(_ data: Data, eventId: UUID) throws {
        ensureFolder()
        try data.write(to: fileURL(eventId: eventId), options: .atomic)
    }

    static func removeImage(eventId: UUID) {
        let url = fileURL(eventId: eventId)
        try? FileManager.default.removeItem(at: url)
    }

    static func loadImage(eventId: UUID) -> UIImage? {
        let url = fileURL(eventId: eventId)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    /// Changes when the on-disk JPEG is added/replaced/removed — use for SwiftUI `.id` so the card refreshes even if `ScheduleEvent` is unchanged.
    static func coverFileFingerprint(eventId: UUID) -> String {
        let url = fileURL(eventId: eventId)
        guard FileManager.default.fileExists(atPath: url.path),
              let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
              let mod = attrs[.modificationDate] as? Date
        else {
            return "0"
        }
        return String(mod.timeIntervalSinceReferenceDate)
    }
}
