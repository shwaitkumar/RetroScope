//
//  Endpoint.swift
//  RetroScope
//
//  Created by Shwait Kumar on 21/12/24.
//

import Foundation

struct Endpoint {
    private let baseURL = "https://roxyapi.com/api/v1/data/astro/astrology/"
    
    var path: String
    var queryItems: [URLQueryItem]? = nil

    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
    
    static func horoscope(for sign: String) -> Endpoint {
        Endpoint(path: "horoscope/\(sign)")
    }
}
