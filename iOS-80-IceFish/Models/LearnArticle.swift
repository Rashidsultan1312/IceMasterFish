import Foundation

enum LearnArticleCategoryStyle: String, CaseIterable {
    case fishing
    case tournaments
}

struct LearnArticle: Identifiable, Hashable {
    let id: String
    let categoryStyle: LearnArticleCategoryStyle
    let categoryTitleKey: String
    let categoryIconAssetName: String
    let titleKey: String
    let summaryKey: String
    let bodyKey: String
    let heroImageAssetName: String

    static let articleBeginners = LearnArticle(
        id: "learn_beginners",
        categoryStyle: .fishing,
        categoryTitleKey: "learn.category.fishing",
        categoryIconAssetName: "LearnCategoryFishIcon",
        titleKey: "learn.article.beginners.title",
        summaryKey: "learn.article.beginners.summary",
        bodyKey: "learn.article.beginners.body",
        heroImageAssetName: "LearnHeroBeginners"
    )

    static let articleEquipment = LearnArticle(
        id: "learn_equipment",
        categoryStyle: .fishing,
        categoryTitleKey: "learn.category.fishing",
        categoryIconAssetName: "LearnCategoryFishIcon",
        titleKey: "learn.article.equipment.title",
        summaryKey: "learn.article.equipment.summary",
        bodyKey: "learn.article.equipment.body",
        heroImageAssetName: "LearnHeroEquipment"
    )

    static let articleTechniques = LearnArticle(
        id: "learn_techniques",
        categoryStyle: .fishing,
        categoryTitleKey: "learn.category.fishing",
        categoryIconAssetName: "LearnCategoryFishIcon",
        titleKey: "learn.article.techniques.title",
        summaryKey: "learn.article.techniques.summary",
        bodyKey: "learn.article.techniques.body",
        heroImageAssetName: "LearnHeroTechniques"
    )

    static let articleSurvival = LearnArticle(
        id: "learn_survival",
        categoryStyle: .tournaments,
        categoryTitleKey: "learn.category.tournaments",
        categoryIconAssetName: "LearnCategoryTournamentIcon",
        titleKey: "learn.article.survival.title",
        summaryKey: "learn.article.survival.summary",
        bodyKey: "learn.article.survival.body",
        heroImageAssetName: "LearnHeroSurvival"
    )

    static let articleTripPlanning = LearnArticle(
        id: "learn_trip_planning",
        categoryStyle: .tournaments,
        categoryTitleKey: "learn.category.tournaments",
        categoryIconAssetName: "LearnCategoryTournamentIcon",
        titleKey: "learn.article.trip_planning.title",
        summaryKey: "learn.article.trip_planning.summary",
        bodyKey: "learn.article.trip_planning.body",
        heroImageAssetName: "LearnHeroTripPlanning"
    )

    static let allSamples: [LearnArticle] = [
        articleBeginners,
        articleEquipment,
        articleTechniques,
        articleSurvival,
        articleTripPlanning
    ]
}
