import SwiftUI
import UIKit

struct EventsEventCardView: View {
    @EnvironmentObject private var loc: LocalizationService

    let item: EventsTabDisplayItem
    var showsHeroChevron: Bool = true
    /// Full body text and expanded hero title (Figma event detail); list uses clipped preview.
    var isDetailPresentation: Bool = false
    var onTap: (() -> Void)?

    private let heroHeight: CGFloat = 176

    private var heroImageName: String {
        switch item.listIndex % 3 {
        case 0: return "EventsCardHeroPhoto"
        case 1: return "EventsCardHeroPhotoB"
        default: return "EventsCardHeroPhotoC"
        }
    }

    private var heroOverlay: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: ColorPalette.eventsCardHeroOverlayBlue.opacity(0), location: 0),
                .init(color: ColorPalette.eventsCardHeroOverlayBlue.opacity(0.2), location: 0.5),
                .init(color: ColorPalette.eventsCardHeroOverlayBlue.opacity(0.8), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        let card = VStack(alignment: .leading, spacing: 0) {
            heroSection
            contentSection
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )

        Group {
            if let onTap {
                Button(action: onTap) { card }.buttonStyle(.plain)
            } else {
                card
            }
        }
    }

    private var heroSection: some View {
        ZStack(alignment: .topLeading) {
            Group {
                if let ui = EventCoverImageStorage.loadImage(eventId: item.id) {
                    Image(uiImage: ui)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(heroImageName)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: heroHeight)
            .clipped()

            heroOverlay
                .frame(maxWidth: .infinity)
                .frame(height: heroHeight)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    if item.showFeaturedBadge {
                        featuredBadge
                    }
                    Spacer(minLength: 8)
                    if item.showUpcomingBadge {
                        upcomingBadge
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)

                Spacer(minLength: 0)

                HStack(alignment: .bottom, spacing: 8) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(ColorPalette.eventsCardTitleOnHero)
                        .multilineTextAlignment(.leading)
                        .lineLimit(isDetailPresentation ? nil : 2)
                        .shadow(color: ColorPalette.eventsCardTitleOnHeroShadow, radius: 3, x: 0, y: 2)
                        .shadow(color: ColorPalette.eventsCardTitleOnHeroShadow.opacity(0.5), radius: 8, x: 0, y: 4)

                    Spacer(minLength: 0)

                    if showsHeroChevron {
                        heroChevron
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .frame(maxWidth: .infinity, minHeight: heroHeight, maxHeight: heroHeight, alignment: .topLeading)
        }
        .frame(height: heroHeight)
    }

    private var featuredBadge: some View {
        HStack(spacing: 4) {
            Image("EventsCardBadgeFeaturedIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
            Text(loc.localized("events.badge.featured"))
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(ColorPalette.eventsFeaturedBadgeText)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(
            LinearGradient(
                colors: [
                    ColorPalette.eventsFeaturedBadgeGradientStart,
                    ColorPalette.eventsFeaturedBadgeGradientEnd
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(Capsule(style: .continuous))
        .shadow(color: ColorPalette.eventsFeaturedBadgeShadow, radius: 3, x: 0, y: 2)
    }

    private var upcomingBadge: some View {
        HStack(spacing: 4) {
            Image("EventsCardBadgeUpcomingIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
            Text(loc.localized("events.badge.upcoming"))
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(ColorPalette.eventsUpcomingBadgeText)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(ColorPalette.eventsUpcomingBadgeFill)
        .clipShape(Capsule(style: .continuous))
        .shadow(color: ColorPalette.eventsUpcomingBadgeShadow, radius: 3, x: 0, y: 2)
    }

    private var heroChevron: some View {
        ZStack {
            Circle()
                .fill(ColorPalette.eventsCardHeroChevronFill)
            Circle()
                .stroke(ColorPalette.eventsCardHeroChevronStroke, lineWidth: 1)
            Image("EventsCardHeroChevron")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
        .frame(width: 36, height: 36)
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if item.body.isEmpty {
                Text(loc.localized("events.card.no_notes"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorPalette.textMuted)
                    .multilineTextAlignment(.leading)
                    .lineLimit(isDetailPresentation ? nil : 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(item.body)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorPalette.eventsCardBody)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .lineLimit(isDetailPresentation ? nil : 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            metaFooterRow
        }
        .padding(.top, 15)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ColorPalette.background)
    }

    private var metaFooterRow: some View {
        HStack(alignment: .center, spacing: 12) {
            dateMetaChip(text: formattedDate(item.startDate))
            Spacer(minLength: 16)
            secondaryMetaChip
        }
    }

    private func dateMetaChip(text: String) -> some View {
        HStack(spacing: 8) {
            metaIcon("EventsCardMetaDateIcon", background: ColorPalette.eventsCardMetaDateIconBackground)
            Text(text)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.eventsCardDateRowText)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
    }

    @ViewBuilder
    private var secondaryMetaChip: some View {
        switch item.secondaryLine {
        case .location(let string):
            let display = string.isEmpty ? loc.localized("events.row.location_placeholder") : string
            HStack(spacing: 8) {
                metaIcon("EventsCardMetaLocationIcon", background: ColorPalette.eventsCardMetaSecondaryBackground)
                Text(display)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorPalette.eventsCardBody)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
        case .members(let count):
            let formatted = String(format: loc.localized("events.row.members_format"), count)
            HStack(spacing: 8) {
                metaIcon("EventsCardMetaMembersIcon", background: ColorPalette.eventsCardMetaSecondaryBackground)
                Text(formatted)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorPalette.eventsCardBody)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
        }
    }

    private func metaIcon(_ name: String, background: Color) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: 16, height: 16)
            .padding(6)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: loc.language == .de ? "de_DE" : "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMM d yyyy")
        return formatter.string(from: date)
    }
}

#Preview {
    EventsEventCardView(
        item: EventsTabDisplayItem(
            id: UUID(),
            title: "Winter Championship 2025",
            body: "Annual ice fishing championship open to all registered teams. Compete for the grand trophy and cash prizes.",
            startDate: Date(),
            secondaryLine: .location("Lake Baikal"),
            showFeaturedBadge: true,
            showUpcomingBadge: true,
            listIndex: 0
        ),
        onTap: {}
    )
    .padding()
    .environmentObject(LocalizationService.shared)
}
