import Foundation

enum OpenAIServiceError: Error, LocalizedError {
    case missingAPIKey
    case invalidURL
    case emptyResponseBody
    case httpStatus(Int, String?)
    case decodingFailed
    case noChoiceContent
    case noImageData

    var errorDescription: String? {
        switch self {
        case .missingAPIKey: return "OpenAI API key missing"
        case .invalidURL: return "Invalid OpenAI URL"
        case .emptyResponseBody: return "Empty response"
        case .httpStatus(let code, _): return "HTTP \(code)"
        case .decodingFailed: return "Invalid API response"
        case .noChoiceContent: return "No assistant message"
        case .noImageData: return "No image in response"
        }
    }
}

/// Payload for `v1/chat/completions` `messages` array.
struct OpenAIChatCompletionMessage: Encodable {
    let role: String
    let content: String
}

private struct OpenAIChatRequest: Encodable {
    let model: String
    let messages: [OpenAIChatCompletionMessage]
}

private struct OpenAIChatResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let role: String?
            let content: String?
        }
        let message: Message?
    }
    let choices: [Choice]?
}

private struct OpenAIImageRequest: Encodable {
    let model: String
    let prompt: String
    let n: Int
    let size: String
    let responseFormat: String

    enum CodingKeys: String, CodingKey {
        case model, prompt, n, size
        case responseFormat = "response_format"
    }
}

private struct OpenAIImageResponse: Decodable {
    struct Item: Decodable {
        let b64Json: String?
        let url: String?

        enum CodingKeys: String, CodingKey {
            case b64Json = "b64_json"
            case url
        }
    }
    let data: [Item]?
}

final class OpenAIService {
    static let shared = OpenAIService()

    private let configuration: OpenAIConfiguration
    private let session: URLSession

    init(configuration: OpenAIConfiguration = .fromBundle, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    /// Sends chat messages (include system first if needed) and returns assistant text.
    func sendChat(messages: [OpenAIChatCompletionMessage]) async throws -> String {
        guard let apiKey = configuration.apiKey, !apiKey.isEmpty else {
            throw OpenAIServiceError.missingAPIKey
        }
        let url = configuration.baseURL.appendingPathComponent("chat/completions")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = OpenAIChatRequest(model: configuration.chatModel, messages: messages)
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await session.data(for: request)
        try throwIfHTTPError(data: data, response: response)

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(OpenAIChatResponse.self, from: data),
              let text = decoded.choices?.first?.message?.content?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty
        else {
            throw OpenAIServiceError.noChoiceContent
        }
        return text
    }

    /// Returns PNG image data from DALL-E (base64).
    func generateImageData(prompt: String, size: String = "1024x1024") async throws -> Data {
        guard let apiKey = configuration.apiKey, !apiKey.isEmpty else {
            throw OpenAIServiceError.missingAPIKey
        }
        let url = configuration.baseURL.appendingPathComponent("images/generations")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = OpenAIImageRequest(
            model: configuration.imageModel,
            prompt: prompt,
            n: 1,
            size: size,
            responseFormat: "b64_json"
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await session.data(for: request)
        try throwIfHTTPError(data: data, response: response)

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(OpenAIImageResponse.self, from: data),
              let first = decoded.data?.first
        else {
            throw OpenAIServiceError.decodingFailed
        }

        if let b64 = first.b64Json, let imageData = Data(base64Encoded: b64) {
            return imageData
        }
        if let urlString = first.url, let imageURL = URL(string: urlString) {
            let (imgData, imgResp) = try await session.data(from: imageURL)
            guard let http = imgResp as? HTTPURLResponse, (200 ... 299).contains(http.statusCode) else {
                throw OpenAIServiceError.noImageData
            }
            return imgData
        }
        throw OpenAIServiceError.noImageData
    }

    private func throwIfHTTPError(data: Data, response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw OpenAIServiceError.httpStatus(-1, nil)
        }
        guard (200 ... 299).contains(http.statusCode) else {
            let snippet = String(data: data, encoding: .utf8)
            throw OpenAIServiceError.httpStatus(http.statusCode, snippet)
        }
    }
}
