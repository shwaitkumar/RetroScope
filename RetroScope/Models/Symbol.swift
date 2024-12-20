//
//  Symbol.swift
//  RetroScope
//
//  Created by Shwait Kumar on 14/12/24.
//

import Foundation

struct Symbol: Identifiable, Equatable, Hashable, Decodable, Encodable {
    let id: UUID
    var name: String
    
    // Computed Property for `arrayOfName`
    var arrayOfName: [Character] {
        Array(name)
    }
    
    static func == (lhs: Symbol, rhs: Symbol) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

extension Symbol {
    static let symbols: [Symbol] = [
        .init(id: UUID(), name: "Aries"),
        .init(id: UUID(), name: "Taurus"),
        .init(id: UUID(), name: "Gemini"),
        .init(id: UUID(), name: "Cancer"),
        .init(id: UUID(), name: "Leo"),
        .init(id: UUID(), name: "Virgo"),
        .init(id: UUID(), name: "Libra"),
        .init(id: UUID(), name: "Scorpio"),
        .init(id: UUID(), name: "Sagittarius"),
        .init(id: UUID(), name: "Capricorn"),
        .init(id: UUID(), name: "Aquarius"),
        .init(id: UUID(), name: "Pisces")
    ]
}
