//
//  ContentView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 14/12/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("storedSymbol") var storedSymbol: String?
    
    @State private var isShowingSelectSignView: Bool = false
    @State private var selectedSymbol: Symbol?
    
    var body: some View {
        ZStack {
            Color.ivoryGlow
                .ignoresSafeArea(.all)
            
            switch isShowingSelectSignView {
                case true:
                ChooseSymbolView(selectedSymbol: $selectedSymbol)
                
            case false:
                if let selectedSymbol = selectedSymbol {
                    HomeView(selectedSymbol: selectedSymbol, isShowingSelectSignView: $isShowingSelectSignView)
                }
            }
        } //: ZSTACK
        .onAppear {
            guard storedSymbol != nil else {
                isShowingSelectSignView.toggle()
                return
            }
            
            guard let symbol = convertFromStringToSymbol() else {
                return
            }
            
            selectedSymbol = symbol
        }
        .onChange(of: selectedSymbol, {
            if isShowingSelectSignView {
                isShowingSelectSignView.toggle()
            }
        })
    }
    
    private func convertFromStringToSymbol() -> Symbol? {
        guard let storedSymbol = storedSymbol else {
            print("Failed to retrieve stored symbol")
            return nil
        }
        
        print("Stored Symbol: \(storedSymbol)")
        
        if let data = storedSymbol.data(using: .utf8) {
            do {
                let symbol = try JSONDecoder().decode(Symbol.self, from: data)
                print("Converted Symbol: \(symbol)")
                return symbol
            } catch {
                print("JSON Decoding error: \(error.localizedDescription)")
                return nil
            }
        } else {
            print("Failed to convert stored symbol string to Data")
            return nil
        }
    }
}

#Preview {
    ContentView()
}
