import Foundation
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var currentSlide: OnboardingSlide = .aiTips

    private let completionStore: OnboardingCompletionStore
    private let localization: LocalizationService

    var onFinished: (() -> Void)?

    init(
        completionStore: OnboardingCompletionStore = .shared,
        localization: LocalizationService = .shared
    ) {
        self.completionStore = completionStore
        self.localization = localization
    }

    var slideIndex: Int {
        currentSlide.rawValue
    }

    func skip() {
        finish()
    }

    func advance() {
        switch currentSlide {
        case .aiTips:
            currentSlide = .teams
        case .teams:
            currentSlide = .planTrack
        case .planTrack:
            currentSlide = .language
        case .language:
            finish()
        }
    }

    private func finish() {
        completionStore.markCompleted()
        onFinished?()
    }

    /// Writes immediately to ``LocalizationService/language`` (same as Settings) so UI updates in real time.
    func selectLanguage(_ language: LocalizationService.Language) {
        localization.language = language
    }
}
