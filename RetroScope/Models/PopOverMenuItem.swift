//
//  PopOverMenuItem.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import Foundation
import SwiftUI

struct PopOverMenuItem: Identifiable {
    var id = UUID()
    let title: PopOverMenuTitle
    let color: Color
}

enum PopOverMenuTitle: String {
    case changeSign = "Change Sign"
    case reset = "Reset"
}

extension PopOverMenuItem {
    static let popOverMenuItems: [PopOverMenuItem] = [
        .init(title: .changeSign, color: .royalAmethyst),
        .init(title: .reset, color: .crimsonBlaze)
    ]
}