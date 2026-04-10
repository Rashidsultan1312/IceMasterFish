import SwiftUI

struct LearnTabView: View {
    @EnvironmentObject private var loc: LocalizationService
    @ObservedObject var viewModel: LearnTabViewModel

    @State private var selectedArticle: LearnArticle?

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                AppScreenBackgroundView()

                Image("LearnMainDecor")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: min(geo.size.height * 0.52, 720))
                    .clipped()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .allowsHitTesting(false)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        sectionHeader
                        VStack(spacing: 20) {
                            ForEach(viewModel.articles) { article in
                                LearnArticleCardView(article: article) {
                                    selectedArticle = article
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
            }
        }
        .fullScreenCover(item: $selectedArticle) { article in
            LearnArticleDetailView(article: article)
                .environmentObject(loc)
        }
    }

    private var sectionHeader: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                ColorPalette.eventsSectionIconGradientTop,
                                ColorPalette.eventsSectionIconGradientBottom
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                Image("LearnSectionLatestIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }

            Text(loc.localized("learn.section.latest"))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(ColorPalette.learnArticleTitle)
        }
    }
}

#Preview {
    LearnTabView(viewModel: .preview)
        .environmentObject(LocalizationService.shared)
}
