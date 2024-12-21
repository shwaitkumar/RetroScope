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
                        Rectangle()
                            .fill(.clear)
                        
                        ZStack {
                            Rectangle()
                                .fill(.ivoryGlow.opacity(0.8))
                                .stroke(Color.royalSapphire, lineWidth: 3)
                            
                            VStack(spacing: 32) {
                                Text(error)
                                    .font(.subheadline)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.royalSapphire)
                                    .multilineTextAlignment(.center)
                                
                                HStack(spacing: 24) {
                                    Spacer()
                                    
                                    RetroButtonView(title: "Ok", color: .crimsonBlaze, action: {
                                        dismiss()
                                    })
                                    
                                    Spacer()
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
                        .frame(width: geometry.size.width * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.5))
                        
                        Rectangle()
                            .fill(.clear)
                    } //: VSTACK
                }
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    RetroErrorAlertView(error: "Error", dismiss: {
        print("Button tapped")
    })
}
