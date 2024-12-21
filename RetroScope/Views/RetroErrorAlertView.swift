//
//  RetroErrorAlertView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import SwiftUI

struct RetroErrorAlertView: View {
    let error: String
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
                                .fill(.ivoryGlow.opacity(0.9))
                                .stroke(Color.royalSapphire, lineWidth: 3)
                            
                            VStack(spacing: 32) {
                                Text(error)
                                    .font(.subheadline)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.royalSapphire)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(8)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                HStack(spacing: 24) {
                                    Spacer()
                                    
                                    RetroButtonView(title: "Ok", color: .crimsonBlaze, action: {
                                        dismiss()
                                    })
                                    
                                    Spacer()
                                } //: HSTACK
                                .frame(height: 44)
                                .visualEffect { content, proxy in
                                    content
                                        .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y / 20))
                                }
                            } //: VSTACK
                            .padding(.horizontal)
                            .padding(.vertical)
                            .padding()
                        } //: ZSTACK
                        .frame(width: geometry.size.width * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.5))
                        .frame(maxHeight: .leastNormalMagnitude, alignment: .center)
                        
                        Spacer()
                    } //: VSTACK
                }
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    RetroErrorAlertView(
        error: "Retro Orange comes alive through a spectrum of shades, tints, and tones, each offering a variation of this regal color. Explore the subtle differences and discover how each variant enhances the beauty and versatility of Retro Orange.",
        dismiss: {
        print("Button tapped")
    })
}
