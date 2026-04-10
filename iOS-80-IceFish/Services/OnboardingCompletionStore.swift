import Foundation

final class OnboardingCompletionStore {
    static let shared = OnboardingCompletionStore()

    private let key = "onboarding_completed"

    private init() {}

    var isCompleted: Bool {
        UserDefaults.standard.bool(forKey: key)
    }

    func markCompleted() {
        UserDefaults.standard.set(true, forKey: key)
    }
}
