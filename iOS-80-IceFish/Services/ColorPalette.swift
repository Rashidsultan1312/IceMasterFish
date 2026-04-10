import SwiftUI

enum ColorPalette {
    static let background = Color(red: 1, green: 1, blue: 1)
    static let textPrimary = Color(red: 17 / 255, green: 24 / 255, blue: 39 / 255)
    static let textSecondary = Color(red: 107 / 255, green: 114 / 255, blue: 128 / 255)
    static let textMuted = Color(red: 148 / 255, green: 163 / 255, blue: 184 / 255)
    static let textOnGradient = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let textOnGradientDark = Color(red: 30 / 255, green: 41 / 255, blue: 59 / 255)
    static let divider = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let cardBorder = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let inactiveDot = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let radioStroke = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let skipFill = Color.white.opacity(0.2)
    static let skipStroke = Color.white.opacity(0.4)
    static let germanRowFlagBackground = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let activePillFill = Color.white.opacity(0.25)
    static let activePillStroke = Color.white.opacity(0.3)
    static let shadowBlue = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255).opacity(0.45)
    static let gradientStart = Color(red: 29 / 255, green: 78 / 255, blue: 216 / 255)
    static let gradientMid = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let gradientEnd = Color(red: 14 / 255, green: 165 / 255, blue: 233 / 255)
    static let indicatorGradientStart = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let indicatorGradientEnd = Color(red: 56 / 255, green: 189 / 255, blue: 248 / 255)
    static let languageRowGradientStart = Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255)
    static let languageRowGradientEnd = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)

    static let mainBackgroundTop = Color(red: 234 / 255, green: 243 / 255, blue: 255 / 255)
    static let mainBackgroundBottom = Color(red: 241 / 255, green: 248 / 255, blue: 255 / 255)
    static let teamsSectionBackground = Color(red: 235 / 255, green: 244 / 255, blue: 255 / 255)
    static let aiSectionBackground = Color(red: 238 / 255, green: 246 / 255, blue: 255 / 255)
    static let squadHeading = Color(red: 23 / 255, green: 37 / 255, blue: 84 / 255)
    static let emptyStateBody = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let aiCardTitle = Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255)
    static let aiCardSubtitle = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let teamRankText = Color(red: 30 / 255, green: 41 / 255, blue: 59 / 255)
    static let teamStatNumber = Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255)
    static let teamCardGradientBlob = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let teamLogoGlow = Color(red: 6 / 255, green: 182 / 255, blue: 212 / 255).opacity(0.5)
    static let tabBarBorder = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255).opacity(0.3)
    static let tabInactiveLabel = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let navSettingsFill = Color.white.opacity(0.1)
    static let navSettingsStroke = Color.white.opacity(0.2)

    static let formFieldStrokeBold = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let formPlaceholder = Color(red: 147 / 255, green: 197 / 255, blue: 253 / 255)
    static let presetSelectedFill = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let presetSelectedStroke = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let uploadAreaFill = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255).opacity(0.5)
    static let uploadDashStroke = Color(red: 147 / 255, green: 197 / 255, blue: 253 / 255)
    static let rosterBadgeBackground = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let rosterBadgeText = Color(red: 29 / 255, green: 78 / 255, blue: 216 / 255)
    static let playerRowName = Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255)
    static let playerAvatarAltText = Color(red: 30 / 255, green: 41 / 255, blue: 59 / 255)
    static let removeBadgeRed = Color(red: 239 / 255, green: 68 / 255, blue: 68 / 255)
    static let leagueInactiveText = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let leagueSegmentFill = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)

    static let teamDetailBodyGradientStart = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let teamDetailBodyGradientMid = Color.white
    static let teamDetailBodyGradientEnd = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let deleteButtonGradientStart = Color(red: 1, green: 51 / 255, blue: 51 / 255)
    static let deleteButtonGradientMid = Color(red: 217 / 255, green: 50 / 255, blue: 50 / 255)
    static let deleteButtonGradientEnd = Color(red: 170 / 255, green: 15 / 255, blue: 15 / 255)
    static let rosterInitialsPrimary = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let rosterInitialsAlternate = Color(red: 30 / 255, green: 41 / 255, blue: 59 / 255)

    static let navigationBarGradientStart = Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255)
    static let navigationBarGradientMid = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let navigationBarGradientEnd = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)

    /// Shared blue header gradient (tab header, detail nav bars, primary buttons).
    static var navigationBarLinearGradient: LinearGradient {
        LinearGradient(
            colors: [
                navigationBarGradientStart,
                navigationBarGradientMid,
                navigationBarGradientEnd
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static let chatUserBubbleTop = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let chatUserBubbleBottom = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let chatDatePillBackground = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255).opacity(0.5)
    static let chatInputBarStroke = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let chatInputBarFill = Color.white.opacity(0.9)
    static let chatSendButtonGradientStart = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let chatSendButtonGradientEnd = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let chatBubbleLabel = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let chatAiBubbleStroke = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)

    static let autoNameResultCardGradientStart = Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255)
    static let autoNameResultCardGradientEnd = Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255)
    static let autoNameResultSubtitle = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let autoNameCopyButtonFill = Color.white.opacity(0.1)
    static let autoNameCopyButtonStroke = Color.white.opacity(0.2)
    static let autoNameSectionLabel = Color(red: 23 / 255, green: 37 / 255, blue: 84 / 255)
    static let autoNameToneHint = Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255)

    static let autoLogoResultCardGradientStart = Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255)
    static let autoLogoResultCardGradientEnd = Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255)
    static let autoLogoResultSubtitle = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let autoLogoCrestFrameFill = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let autoLogoCrestFrameStroke = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255).opacity(0.5)

    static let scheduleWeekdayLabel = Color(red: 96 / 255, green: 165 / 255, blue: 250 / 255)
    static let scheduleCalendarDayMuted = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let scheduleCalendarDayPrimary = Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255)
    static let scheduleSelectedDayGradientStart = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let scheduleSelectedDayGradientEnd = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let scheduleEmptyBodyText = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let scheduleEmptyIconRingStroke = Color(red: 147 / 255, green: 197 / 255, blue: 253 / 255)
    static let scheduleEventDayDot = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let scheduleEventCardIconBackground = Color(red: 254 / 255, green: 242 / 255, blue: 242 / 255)
    static let scheduleEventCardIconStroke = Color(red: 254 / 255, green: 226 / 255, blue: 226 / 255)
    static let scheduleEventCardAccentBar = Color(red: 32 / 255, green: 76 / 255, blue: 195 / 255)

    /// Create Event screen (Figma node 55:168 body + fields).
    static let createEventFormFieldStroke = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let createEventFormFieldShadow = Color.black.opacity(0.05)
    static let createEventScreenGradientStart = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let createEventScreenGradientMid = Color.white
    static let createEventScreenGradientEnd = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let createEventNavDropShadow = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255).opacity(0.4)

    static let createEventTeamRowSelectedFillStart = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let createEventTeamRowSelectedFillEnd = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let createEventTeamRowSelectedStroke = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let createEventTeamRadioInnerFill = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let createEventTimeRowLabel = Color(red: 96 / 255, green: 165 / 255, blue: 250 / 255)
    static let createEventDurationLabel = Color(red: 29 / 255, green: 78 / 255, blue: 216 / 255)
    static let createEventDurationValue = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let createEventTeamSubtitleMuted = Color(red: 96 / 255, green: 165 / 255, blue: 250 / 255)

    static let inventoryItemTitleActive = Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255)
    static let inventoryItemTitleInactive = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let inventoryItemSubtitleActive = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let inventoryItemSubtitleInactive = Color(red: 148 / 255, green: 163 / 255, blue: 184 / 255)
    static let inventoryDateRowActive = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let inventoryDateRowInactive = Color(red: 148 / 255, green: 163 / 255, blue: 184 / 255)
    static let inventoryItemCardStrokeActive = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let inventoryItemCardStrokeInactive = Color(red: 226 / 255, green: 232 / 255, blue: 240 / 255)
    static let inventoryActivePillFill = Color(red: 240 / 255, green: 253 / 255, blue: 244 / 255)
    static let inventoryActivePillStroke = Color(red: 134 / 255, green: 239 / 255, blue: 172 / 255)
    static let inventoryActivePillText = Color(red: 22 / 255, green: 101 / 255, blue: 52 / 255)
    static let inventoryInactivePillFill = Color(red: 243 / 255, green: 244 / 255, blue: 246 / 255)
    static let inventoryInactivePillStroke = Color(red: 226 / 255, green: 232 / 255, blue: 240 / 255)
    static let inventoryInactivePillText = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let inventoryEmptyBodyText = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let inventoryStatNumber = Color(red: 30 / 255, green: 64 / 255, blue: 175 / 255)

    private static let inventoryAccentPairs: [[Color]] = [
        [Color(red: 6 / 255, green: 182 / 255, blue: 212 / 255), Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)],
        [Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255), Color(red: 14 / 255, green: 165 / 255, blue: 233 / 255)],
        [Color(red: 168 / 255, green: 85 / 255, blue: 247 / 255), Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)],
        [Color(red: 34 / 255, green: 197 / 255, blue: 94 / 255), Color(red: 16 / 255, green: 185 / 255, blue: 129 / 255)],
        [Color(red: 251 / 255, green: 146 / 255, blue: 60 / 255), Color(red: 234 / 255, green: 88 / 255, blue: 12 / 255)],
        [Color(red: 236 / 255, green: 72 / 255, blue: 153 / 255), Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)]
    ]

    static let inventoryRowAccentPairInactive: [Color] = [
        Color(red: 148 / 255, green: 163 / 255, blue: 184 / 255),
        Color(red: 203 / 255, green: 213 / 255, blue: 225 / 255)
    ]

    static func inventoryRowAccentPair(for index: Int) -> [Color] {
        let i = index % max(inventoryAccentPairs.count, 1)
        return inventoryAccentPairs[i]
    }

    static let createEquipmentIconCellSelectedFill = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let createEquipmentIconCellSelectedStroke = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let createEquipmentIconCellIdleFill = Color(red: 248 / 255, green: 250 / 255, blue: 252 / 255)
    static let createEquipmentIconCellIdleStroke = Color(red: 241 / 255, green: 245 / 255, blue: 249 / 255)
    static let createEquipmentStatusActiveFill = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let createEquipmentStatusStrokeSelected = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255)
    static let createEquipmentStatusStrokeIdle = Color(red: 226 / 255, green: 232 / 255, blue: 240 / 255)

    static let eventsEmptyBodyText = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let eventsCardTitle = Color(red: 23 / 255, green: 37 / 255, blue: 84 / 255)
    static let eventsCardBody = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let eventsCardMeta = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let eventsSectionIconGradientTop = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let eventsSectionIconGradientBottom = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)

    /// Hero photo overlay (Figma: linear 0deg, blue 30/58/138).
    static let eventsCardHeroOverlayBlue = Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255)
    static let eventsCardTitleOnHero = Color.white
    static let eventsCardTitleOnHeroShadow = Color.black.opacity(0.12)
    static let eventsCardHeroChevronFill = Color.white.opacity(0.2)
    static let eventsCardHeroChevronStroke = Color.white.opacity(0.3)

    static let eventsFeaturedBadgeGradientStart = Color(red: 251 / 255, green: 191 / 255, blue: 36 / 255)
    static let eventsFeaturedBadgeGradientEnd = Color(red: 245 / 255, green: 158 / 255, blue: 11 / 255)
    static let eventsFeaturedBadgeText = Color.white
    static let eventsFeaturedBadgeShadow = Color.black.opacity(0.12)

    static let eventsUpcomingBadgeFill = Color(red: 16 / 255, green: 185 / 255, blue: 129 / 255).opacity(0.9)
    static let eventsUpcomingBadgeText = Color.white
    static let eventsUpcomingBadgeShadow = Color.black.opacity(0.12)

    static let eventsCardDateRowText = Color(red: 37 / 255, green: 99 / 255, blue: 235 / 255)
    static let eventsCardMetaDateIconBackground = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let eventsCardMetaSecondaryBackground = Color(red: 248 / 255, green: 250 / 255, blue: 252 / 255)

    static let learnCategoryPillBlue = Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255).opacity(0.9)
    static let learnCategoryPillGreen = Color(red: 16 / 255, green: 185 / 255, blue: 129 / 255).opacity(0.9)
    static let learnArticleTitle = Color(red: 23 / 255, green: 37 / 255, blue: 84 / 255)
    static let learnArticleSummary = Color(red: 100 / 255, green: 116 / 255, blue: 139 / 255)
    static let learnReadButtonFill = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let learnReadButtonStroke = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let learnReadButtonText = Color(red: 29 / 255, green: 78 / 255, blue: 216 / 255)

    /// Settings screen (Figma node 13:3067).
    static let settingsScreenGradientStart = Color(red: 239 / 255, green: 246 / 255, blue: 255 / 255)
    static let settingsScreenGradientMid = Color.white
    static let settingsScreenGradientEnd = Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255)
    static let settingsSectionTitle = Color(red: 23 / 255, green: 37 / 255, blue: 84 / 255)
    static let settingsRowTitle = Color(red: 30 / 255, green: 41 / 255, blue: 59 / 255)
    static let settingsRowSubtitle = Color(red: 148 / 255, green: 163 / 255, blue: 184 / 255)
    static let settingsLanguageMetaOnActive = Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)
    static let settingsRateTitle = Color(red: 30 / 255, green: 41 / 255, blue: 59 / 255)
}
