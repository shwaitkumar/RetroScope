//
//  NetworkManager.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let apiKey = Constants.apiKey

    private init() {}

    // MARK: - Fetch Horoscope
    
    func fetchHoroscope(sign: String) async throws -> Horoscope {
        guard let url = Endpoint.horoscope(for: sign).url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }

            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(Horoscope.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.networkError(error.localizedDescription)
        }
    }
    
}

// MARK: - Supporting Types

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "The server responded with an invalid response."
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}

