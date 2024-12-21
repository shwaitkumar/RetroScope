//
//  RetroButtonView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import SwiftUI

struct RetroButtonView: View {
    var title: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        }, label: {
            ZStack {
                Rectangle()
                    .fill(color.opacity(0.8))
                    .offset(x: 8, y: 8)
                    .overlay {
                        Rectangle()
                            .fill(.clear)
                            .stroke(.royalSapphire, lineWidth: 3)
                        
                        Text(title)
                            .font(.headline)
                            .fontWeight(.medium)
                            .fontDesign(.monospaced)
                            .foregroundStyle(.royalSapphire)
                    }
            } //: ZSTACK
        })
    }
}

#Preview {
    RetroButtonView(title: "Button", color: Color.vibrantGreen, action: {
        print("Button Tapped")
    })
}
