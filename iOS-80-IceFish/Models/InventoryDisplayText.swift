import Foundation

enum InventoryDisplayText: Equatable, Hashable, Codable {
    case localized(key: String)
    case literal(String)
}

extension InventoryDisplayText {
    private enum CodingKeys: String, CodingKey {
        case kind
        case key
        case value
    }

    private enum Kind: String, Codable {
        case localized
        case literal
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        switch kind {
        case .localized:
            let key = try container.decode(String.self, forKey: .key)
            self = .localized(key: key)
        case .literal:
            let value = try container.decode(String.self, forKey: .value)
            self = .literal(value)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .localized(let key):
            try container.encode(Kind.localized, forKey: .kind)
            try container.encode(key, forKey: .key)
        case .literal(let value):
            try container.encode(Kind.literal, forKey: .kind)
            try container.encode(value, forKey: .value)
        }
    }
}

extension InventoryDisplayText {
    func resolved(using loc: LocalizationService) -> String {
        switch self {
        case .localized(let key):
            return loc.localized(key)
        case .literal(let value):
            return value
        }
    }
}
