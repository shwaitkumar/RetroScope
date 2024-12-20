//
//  RetroActionView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import SwiftUI

struct RetroActionView: View {
    let title: String
    let confirm: () -> Void
    let dismiss: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ivoryGlow.opacity(0.8))
                .stroke(Color.royalSapphire, lineWidth: 3)
            
            VStack(spacing: 32) {
                Text(title)
                    .font(.subheadline)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.royalSapphire)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 24) {
                    RetroButtonView(title: "Yes", color: .vibrantGreen, action: {
                        confirm()
                    })
                    
                    RetroButtonView(title: "No", color: .crimsonBlaze, action: {
                        dismiss()
                    })
                } //: HSTACK
                .frame(height: 44)
            } //: VSTACK
            .padding(.horizontal)
            .padding()
        } //: ZSTACK
        .visualEffect { content, proxy in
            content
                .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y / 10))
        }
    }
}

#Preview {
    @Previewable @State var isAnimating: Bool = false
    
    RetroActionView(
        title: "Test",
        confirm: {
        isAnimating.toggle()
    }, dismiss: {
        isAnimating.toggle()
    })
}
