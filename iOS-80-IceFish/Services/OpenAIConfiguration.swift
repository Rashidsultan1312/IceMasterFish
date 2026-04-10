import Foundation

struct OpenAIConfiguration: Sendable {
    var apiKey: String?
    var baseURL: URL
    var chatModel: String
    var imageModel: String

    static let defaultBaseURL = URL(string: "https://api.openai.com/v1")!

    static var fromBundle: OpenAIConfiguration {
        let raw = Bundle.main.object(forInfoDictionaryKey: "API_OPEN_API") as? String
        let trimmed = raw?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let key = trimmed.isEmpty ? nil : trimmed
        return OpenAIConfiguration(
            apiKey: key,
            baseURL: Self.defaultBaseURL,
            chatModel: "gpt-4o-mini",
            imageModel: "dall-e-3"
        )
    }
}
