//
//  Horoscope.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import Foundation

struct Horoscope: Codable, Identifiable, Equatable {
    var id = UUID()
    let sign: String
    let horoscope: String

    private enum CodingKeys: String, CodingKey {
        case sign, horoscope
    }
    
    static func == (lhs: Horoscope, rhs: Horoscope) -> Bool {
        lhs.id == rhs.id
    }
}
