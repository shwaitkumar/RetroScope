//
//  RetroScopeApp.swift
//  RetroScope
//
//  Created by Shwait Kumar on 14/12/24.
//

import SwiftUI

@main
struct RetroScopeApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
