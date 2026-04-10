import Foundation
import UIKit
import Combine

@MainActor
final class AutoLogoGeneratorViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessageKey: String?
    @Published var generatedImage: UIImage?

    private let openAI: OpenAIService
    private var variationCounter = 0

    init(openAI: OpenAIService = .shared) {
        self.openAI = openAI
    }

    func generate(teamName: String, cityRegion: String, swatchIndex: Int, details: String, regenerate: Bool) async {
        if regenerate {
            variationCounter += 1
        } else {
            variationCounter = 0
            generatedImage = nil
        }

        errorMessageKey = nil
        isLoading = true
        defer { isLoading = false }

        let name = teamName.trimmingCharacters(in: .whitespacesAndNewlines)
        let city = cityRegion.trimmingCharacters(in: .whitespacesAndNewlines)
        let detailBlock = details.trimmingCharacters(in: .whitespacesAndNewlines)

        let displayName = name.isEmpty ? "Ice Fishing Team" : name
        let regionLine = city.isEmpty ? "unspecified cold-climate region" : city
        let palette = paletteDescriptionEnglish(swatchIndex)

        var prompt = """
        Flat vector emblem, ice fishing sports team crest, centered, bold simple shapes, no photorealism. \
        Team identity: "\(displayName)". Region: \(regionLine). \
        Color palette emphasis: \(palette). \
        Style: sticker/badge suitable as mobile app team logo, clean edges, minimal detail.
        """
        if !detailBlock.isEmpty {
            prompt += " Extra direction: \(detailBlock)."
        }
        if variationCounter > 0 {
            prompt += " Visual variation \(variationCounter): change composition or symbols while keeping the same theme."
        }

        do {
            let data = try await openAI.generateImageData(prompt: prompt, size: "1024x1024")
            if let img = UIImage(data: data) {
                generatedImage = img
            } else {
                errorMessageKey = "openai.error.image_decode"
            }
        } catch let error as OpenAIServiceError {
            switch error {
            case .missingAPIKey:
                errorMessageKey = "openai.error.no_api_key"
            case .httpStatus:
                errorMessageKey = "openai.error.network"
            case .noImageData, .noChoiceContent, .decodingFailed, .emptyResponseBody, .invalidURL:
                errorMessageKey = "openai.error.generic"
            }
        } catch {
            errorMessageKey = "openai.error.generic"
        }
    }

    private func paletteDescriptionEnglish(_ index: Int) -> String {
        switch index {
        case 0: return "strong blue and white accents"
        case 1: return "teal and aqua with white highlights"
        case 2: return "purple, magenta, and warm accent gradients"
        case 3: return "orange and deep amber with contrast neutrals"
        case 4: return "emerald green and mint with dark contrast"
        case 5: return "gold and amber with deep blue contrast"
        default: return "blue and white"
        }
    }
}
