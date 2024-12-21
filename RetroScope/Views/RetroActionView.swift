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
        GeometryReader { geometry in
            Rectangle()
                .foregroundStyle(Color.royalSapphire.opacity(0.5))
                .overlay {
                    VStack {
                        Spacer()
                        
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
                                    .lineLimit(8)
                                    .fixedSize(horizontal: false, vertical: true)
                                
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
                            .padding(.vertical)
                            .padding()
                        } //: ZSTACK
                        .frame(width: geometry.size.width * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.5))
                        .frame(maxHeight: .leastNormalMagnitude, alignment: .center)
                        .visualEffect { content, proxy in
                            content
                                .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y / 10))
                        }
                        
                        Spacer()
                    } //: VSTACK
                }
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    @Previewable @State var isAnimating: Bool = false
    
    RetroActionView(
        title: "Retro Orange comes alive through a spectrum of shades, tints, and tones, each offering a variation of this regal color. Explore the subtle differences and discover how each variant enhances the beauty and versatility of Retro Orange.",
        confirm: {
            isAnimating.toggle()
        }, dismiss: {
            isAnimating.toggle()
        })
}
