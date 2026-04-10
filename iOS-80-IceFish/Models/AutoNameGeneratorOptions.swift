import Foundation

enum AutoNameWordOption: Int, CaseIterable, Identifiable {
    case one = 1
    case two = 2
    case three = 3

    var id: Int { rawValue }
}

enum AutoNameToneOption: String, CaseIterable, Identifiable {
    case strictProfessional
    case entertaining
    case playful

    var id: String { rawValue }
}
