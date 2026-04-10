import Foundation

enum OnboardingSlide: Int, CaseIterable {
    case aiTips
    case teams
    case planTrack
    case language

    var heroImageAssetName: String? {
        switch self {
        case .aiTips: return "OnboardingHero1"
        case .teams: return "OnboardingHero2"
        case .planTrack: return "OnboardingHero3"
        case .language: return nil
        }
    }

    var titleKey: String {
        switch self {
        case .aiTips: return "onboarding.slide1.title"
        case .teams: return "onboarding.slide2.title"
        case .planTrack: return "onboarding.slide3.title"
        case .language: return "onboarding.language.title"
        }
    }

    var subtitleKey: String {
        switch self {
        case .aiTips: return "onboarding.slide1.subtitle"
        case .teams: return "onboarding.slide2.subtitle"
        case .planTrack: return "onboarding.slide3.subtitle"
        case .language: return "onboarding.language.subtitle"
        }
    }

    var showsPageIndicators: Bool {
        self != .language
    }
}
