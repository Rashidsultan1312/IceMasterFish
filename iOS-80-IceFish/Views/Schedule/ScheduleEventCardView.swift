import SwiftUI
import UIKit

struct ScheduleEventCardView: View {
    @EnvironmentObject private var loc: LocalizationService
    let event: ScheduleEvent

    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                eventThumbnail

                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(ColorPalette.autoNameSectionLabel)
                        .fixedSize(horizontal: false, vertical: true)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image("ScheduleEventTimeIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Text(timeRangeFormatted)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(ColorPalette.leagueInactiveText)
                        }

                        HStack(spacing: 8) {
                            Image("ScheduleEventLocationIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Text(event.location)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(ColorPalette.leagueInactiveText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
            }
            .padding(.leading, 10)
            .padding([.vertical, .trailing], 16)

            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(ColorPalette.scheduleEventCardAccentBar)
                .frame(width: 6)
                .padding(.vertical, 1)
                .padding(.leading, 1)
        }
        .background(ColorPalette.background)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }

    /// Matches `EventsEventCardView` / `CreateEventViewModel`: JPEG at `EventCoverImages/{eventId}.jpg`.
    private var eventThumbnail: some View {
        ZStack {
            ColorPalette.scheduleEventCardIconBackground
            Group {
                if let ui = EventCoverImageStorage.loadImage(eventId: event.id) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image("ScheduleEventFishBlock")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .frame(width: 72, height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ColorPalette.scheduleEventCardIconStroke, lineWidth: 1)
        )
        .id("\(event.id.uuidString)-\(EventCoverImageStorage.coverFileFingerprint(eventId: event.id))")
    }

    private var timeRangeFormatted: String {
        let df = DateFormatter()
        df.locale = Locale(identifier: loc.language.rawValue)
        df.timeStyle = .short
        return "\(df.string(from: event.startDateTime)) – \(df.string(from: event.endDateTime))"
    }
}

#Preview {
    let cal = Calendar.current
    let day = cal.date(from: DateComponents(year: 2025, month: 2, day: 14))!
    let start = cal.date(bySettingHour: 9, minute: 0, second: 0, of: day) ?? day
    let end = cal.date(bySettingHour: 13, minute: 0, second: 0, of: day) ?? day
    return ScheduleEventCardView(
        event: ScheduleEvent(
            id: UUID(),
            title: "Trophy Catch Session",
            startDateTime: start,
            endDateTime: end,
            location: "Lake Michigan, North Pier",
            notes: "",
            teamId: nil
        )
    )
    .padding()
    .environmentObject(LocalizationService.shared)
}
