import Combine
import Foundation

@MainActor
final class LearnTabViewModel: ObservableObject {
    let articles: [LearnArticle]

    init(articles: [LearnArticle] = LearnArticle.allSamples) {
        self.articles = articles
    }
}

extension LearnTabViewModel {
    static var preview: LearnTabViewModel {
        LearnTabViewModel()
    }
}
