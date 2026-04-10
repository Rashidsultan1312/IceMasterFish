import SwiftUI

struct LearnArticleCardView: View {
    @EnvironmentObject private var loc: LocalizationService

    let article: LearnArticle
    var onTap: () -> Void

    private let heroHeight: CGFloat = 192

    private var categoryPillBackground: Color {
        switch article.categoryStyle {
        case .fishing: return ColorPalette.learnCategoryPillBlue
        case .tournaments: return ColorPalette.learnCategoryPillGreen
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    Image(article.heroImageAssetName)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: heroHeight)
                        .clipped()

                    categoryPill
                        .padding(12)
                }
                .frame(height: heroHeight)

                VStack(alignment: .leading, spacing: 11) {
                    Text(loc.localized(article.titleKey))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(ColorPalette.learnArticleTitle)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(loc.localized(article.summaryKey))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ColorPalette.learnArticleSummary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    readArticleRow
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ColorPalette.background)
            }
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(ColorPalette.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var categoryPill: some View {
        HStack(spacing: 4) {
            Image(article.categoryIconAssetName)
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
            Text(loc.localized(article.categoryTitleKey))
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(ColorPalette.background)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 12)
        .background(categoryPillBackground)
        .clipShape(Capsule(style: .continuous))
        .shadow(color: Color.black.opacity(0.12), radius: 3, x: 0, y: 2)
    }

    private var readArticleRow: some View {
        HStack(spacing: 8) {
            Text(loc.localized("learn.read_article"))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorPalette.learnReadButtonText)
            Image("LearnReadArticleArrow")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(ColorPalette.learnReadButtonFill)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(ColorPalette.learnReadButtonStroke, lineWidth: 1)
        )
        .padding(.top, 8)
    }
}

#Preview {
    LearnArticleCardView(article: .articleBeginners, onTap: {})
        .padding()
        .environmentObject(LocalizationService.shared)
}
