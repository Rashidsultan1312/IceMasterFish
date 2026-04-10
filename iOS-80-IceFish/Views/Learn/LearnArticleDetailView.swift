import SwiftUI

struct LearnArticleDetailView: View {
    @EnvironmentObject private var loc: LocalizationService

    let article: LearnArticle

    private let heroHeight: CGFloat = 176

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

    private var mainContentGradient: LinearGradient {
        LinearGradient(
            colors: [ColorPalette.mainBackgroundTop, ColorPalette.mainBackgroundBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                mainContentGradient
                    .ignoresSafeArea()

                Image("LearnDetailDecor")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: min(geo.size.height * 0.52, 660))
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    AppDetailNavigationBar(
                        topInset: geo.safeAreaInsets.top,
                        title: loc.localized("learn.detail.nav_title"),
                        backButtonImageName: "CreateEventNavBack",
                        titleLetterSpacing: -0.6
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        articleCard
                            .padding(.horizontal, 20)
                            .padding(.top, 32)
                            .padding(.bottom, 48)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
    }

    private var articleCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                Image(article.heroImageAssetName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: heroHeight)
                    .clipped()

                heroOverlay
                    .frame(maxWidth: .infinity)
                    .frame(height: heroHeight)
                    .allowsHitTesting(false)

                Text(loc.localized(article.titleKey))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorPalette.eventsCardTitleOnHero)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .shadow(color: ColorPalette.eventsCardTitleOnHeroShadow, radius: 3, x: 0, y: 2)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .frame(height: heroHeight)

            Text(loc.localized(article.bodyKey))
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorPalette.eventsCardBody)
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .padding(.top, 15)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorPalette.background)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(ColorPalette.cardBorder, lineWidth: 1)
        )
    }
}

#Preview {
    LearnArticleDetailView(article: .articleBeginners)
        .environmentObject(LocalizationService.shared)
}
