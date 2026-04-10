import Foundation
import Combine

@MainActor
final class AutoNameGeneratorViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessageKey: String?
    @Published var generatedName: String?

    private let openAI: OpenAIService

    init(openAI: OpenAIService = .shared) {
        self.openAI = openAI
    }

    func generate(wordCount: AutoNameWordOption, tone: AutoNameToneOption, exampleHint: String) async {
        errorMessageKey = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let system = """
            You invent exactly one creative ice fishing team name. Reply with the name only: no quotes, no labels, no explanation, no bullet points.
            """
            let toneLine = toneDescriptionEnglish(tone)
            let trimmedExample = exampleHint.trimmingCharacters(in: .whitespacesAndNewlines)
            var user = "Word count: exactly \(wordCount.rawValue) word(s).\nStyle: \(toneLine)."
            if !trimmedExample.isEmpty {
                user += "\nUser example inspiration (do not copy verbatim): \(trimmedExample)"
            }

            let messages = [
                OpenAIChatCompletionMessage(role: "system", content: system),
                OpenAIChatCompletionMessage(role: "user", content: user)
            ]
            var text = try await openAI.sendChat(messages: messages)
            text = sanitizeNameResponse(text)
            guard !text.isEmpty else {
                errorMessageKey = "openai.error.empty_name"
                return
            }
            generatedName = text
        } catch let error as OpenAIServiceError {
            switch error {
            case .missingAPIKey:
                errorMessageKey = "openai.error.no_api_key"
            case .httpStatus:
                errorMessageKey = "openai.error.network"
            case .noChoiceContent, .decodingFailed, .noImageData, .emptyResponseBody, .invalidURL:
                errorMessageKey = "openai.error.generic"
            }
        } catch {
            errorMessageKey = "openai.error.generic"
        }
    }

    private func toneDescriptionEnglish(_ tone: AutoNameToneOption) -> String {
        switch tone {
        case .strictProfessional:
            return "Strict and professional; serious tournament-style naming."
        case .entertaining:
            return "Entertaining and memorable; fun but not offensive."
        case .playful:
            return "Playful, witty, light humor related to fishing or ice; avoid slurs or hateful content."
        }
    }

    private func sanitizeNameResponse(_ raw: String) -> String {
        var s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("\"") { s.removeFirst() }
        if s.hasSuffix("\"") { s.removeLast() }
        if s.hasPrefix("'") { s.removeFirst() }
        if s.hasSuffix("'") { s.removeLast() }
        if let line = s.split(separator: "\n", omittingEmptySubsequences: false).map(String.init).first {
            s = line.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return s
    }
}
