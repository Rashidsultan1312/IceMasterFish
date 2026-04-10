import Foundation
import Combine

/// Single source of truth for in-app language: change ``language`` (e.g. from Settings or onboarding) and all views
/// using `@EnvironmentObject LocalizationService` + `localized(_:)` refresh without caching strings outside `body`.
final class LocalizationService: ObservableObject {
    static let shared = LocalizationService()

    @Published var language: Language {
        didSet {
            guard language != oldValue else { return }
            UserDefaults.standard.set(language.rawValue, forKey: "app_language")
            loadBundle()
        }
    }

    private(set) var bundle: Bundle = .main

    enum Language: String, CaseIterable, Identifiable {
        case en
        case de

        var id: String { rawValue }

        var displayName: String {
            switch self {
            case .en: return "English"
            case .de: return "Deutsch"
            }
        }
    }

    private init() {
        let saved = UserDefaults.standard.string(forKey: "app_language") ?? Language.en.rawValue
        self.language = Language(rawValue: saved) ?? .en
        loadBundle()
    }

    private func loadBundle() {
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
              let localizedBundle = Bundle(path: path) else {
            bundle = .main
            return
        }
        bundle = localizedBundle
    }

    func localized(_ key: String) -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
