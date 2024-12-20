//
//  String+Extensions.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import Foundation

extension String {
    func toSymbol() -> Symbol? {
        guard let data = self.data(using: .utf8) else {
            print("Failed to convert string to data")
            return nil
        }

        do {
            let symbol = try JSONDecoder().decode(Symbol.self, from: data)
            return symbol
        } catch {
            print("JSON Decoding error: \(error.localizedDescription)")
            return nil
        }
    }
}
