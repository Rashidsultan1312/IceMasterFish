import Foundation
import Combine

@MainActor
final class AICoachChatViewModel: ObservableObject {
    @Published private(set) var messages: [CoachChatMessage] = []
    @Published var isTyping = false
    @Published var errorBannerKey: String?

    let kind: AICoachChatKind

    private let openAI: OpenAIService
    private var didBootstrap = false

    init(kind: AICoachChatKind, openAI: OpenAIService = .shared) {
        self.kind = kind
        self.openAI = openAI
    }

    func bootstrapIfNeeded(intro: String) {
        guard !didBootstrap else { return }
        didBootstrap = true
        messages = [CoachChatMessage(role: .assistant, text: intro)]
    }

    /// Updates the initial assistant greeting when language changes and the user has not sent a message yet.
    func refreshLocalizedIntro(intro: String) {
        guard messages.count == 1, let first = messages.first, first.role == .assistant else { return }
        messages = [CoachChatMessage(role: .assistant, text: intro)]
    }

    func send(userText: String) async {
        let trimmed = userText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        errorBannerKey = nil
        messages.append(CoachChatMessage(role: .user, text: trimmed))

        isTyping = true
        defer { isTyping = false }

        var apiMessages: [OpenAIChatCompletionMessage] = [
            OpenAIChatCompletionMessage(role: "system", content: systemPromptEnglish)
        ]
        for m in messages {
            switch m.role {
            case .user:
                apiMessages.append(OpenAIChatCompletionMessage(role: "user", content: m.text))
            case .assistant:
                apiMessages.append(OpenAIChatCompletionMessage(role: "assistant", content: m.text))
            }
        }

        do {
            let reply = try await openAI.sendChat(messages: apiMessages)
            let cleaned = reply.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !cleaned.isEmpty else {
                errorBannerKey = "openai.error.generic"
                return
            }
            messages.append(CoachChatMessage(role: .assistant, text: cleaned))
        } catch let error as OpenAIServiceError {
            switch error {
            case .missingAPIKey:
                errorBannerKey = "openai.error.no_api_key"
            case .httpStatus:
                errorBannerKey = "openai.error.network"
            case .noChoiceContent, .decodingFailed, .noImageData, .emptyResponseBody, .invalidURL:
                errorBannerKey = "openai.error.generic"
            }
        } catch {
            errorBannerKey = "openai.error.generic"
        }
    }

    private var systemPromptEnglish: String {
        let scopeRules = """
        You operate ONLY inside this mobile app (IceFish) as a fishing coach. Stay strictly on-topic.

        ALLOWED: ice fishing and winter angling only—safety on ice, clothing and gear, rods, augers, shelters, \
        bait and lures, species-appropriate tactics, locating fish under ice, reading weather and ice conditions, \
        conservation and ethics, trip planning tied to fishing. You may give brief, realistic tips about organizing \
        a team or outing when it clearly supports fishing preparation. Do not invent specific app screens, buttons, \
        or data you were not given.

        NOT ALLOWED: anything unrelated—politics, religion, news, celebrities, sports unrelated to ice fishing, \
        coding, homework, math, general small talk, medical or legal advice, finance, mental health treatment, \
        NSFW content, illegal activity, or other apps and products. If asked, refuse briefly with no lecture.

        OFF-TOPIC HANDLING: Reply in the SAME language the user wrote in. Give one or two short sentences: \
        you only help with ice fishing (and this coach’s focus below); invite them to ask a fishing-related \
        question. Do not answer the off-topic request at all.

        QUALITY: No role-play outside being this coach. No disclaimers longer than necessary. No medical or legal \
        claims; suggest qualified professionals when relevant. Keep on-topic replies under about 120 words unless \
        the user explicitly asks for more detail.
        """

        switch kind {
        case .fishing:
            return """
            \(scopeRules)
            You are the Fishing Coach: emphasize safety, gear, bait, locating fish, and reading conditions for \
            recreational ice fishing.
            """
        case .tournament:
            return """
            \(scopeRules)
            You are the Tournament Coach: emphasize practice structure, mental prep, rules awareness, time \
            management, and adapting strategy across tournament sessions—all in the context of ice fishing \
            competition.
            """
        }
    }
}
