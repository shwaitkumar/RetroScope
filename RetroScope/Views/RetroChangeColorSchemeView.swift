//
//  RetroChangeColorSchemeView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 21/12/24.
//

import SwiftUI

struct RetroChangeColorSchemeView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    @State private var isAnimating: Bool = false
    
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
                                HStack {
                                    Button(action: {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        withAnimation(.easeInOut.delay(0.3), {
                                            isDarkMode.toggle()
                                        })
                                    }, label: {
                                        HStack {
                                            Image(systemName: isDarkMode ? "sun.max" : "sun.max.fill")
                                                .foregroundStyle(Color.amberGlow)
                                            
                                            Text("Light")
                                                .foregroundStyle(.royalSapphire)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(5)
                                                .fixedSize(horizontal: false, vertical: true)
                                        } //: HSTACK
                                        .font(.subheadline)
                                        .fontWeight(isDarkMode ? .regular : .bold)
                                        .fontDesign(.monospaced)
                                        .padding()
                                    })
                                    
                                    Button(action: {
                                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                                        withAnimation(.easeInOut.delay(0.3), {
                                            isDarkMode.toggle()
                                        })
                                    }, label: {
                                        HStack {
                                            Image(systemName: isDarkMode ? "moon.stars.fill" : "moon.stars")
                                                .foregroundStyle(Color.azureSky)
                                            
                                            Text("Dark")
                                                .foregroundStyle(.royalSapphire)
                                                .multilineTextAlignment(.leading)
                                                .lineLimit(8)
                                                .fixedSize(horizontal: false, vertical: true)
                                        } //: HSTACK
                                        .font(.subheadline)
                                        .fontWeight(isDarkMode ? .bold : .regular)
                                        .fontDesign(.monospaced)
                                        .padding()
                                    })
                                } //: HSTACK
                                .background(
                                    Color.ivoryGlow
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .overlay {
                                    GeometryReader { geometry in
                                        Rectangle()
                                            .stroke(.vibrantGreen, lineWidth: 3)
                                            .frame(width: geometry.size.width / 2)
                                            .offset(x: isDarkMode ? geometry.size.width / 2 : 0)
                                            .animation(.easeInOut(duration: 0.3), value: isDarkMode)
                                    }
                                }
                                
                                HStack(spacing: 24) {
                                    Spacer()
                                    
                                    RetroButtonView(title: "Ok", color: .vibrantGreen, action: {
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
                        .scaleEffect(isAnimating ? 1 : 0)
                        .animation(.bouncy(duration: 0.5), value: isAnimating)
                        .onAppear {
                            isAnimating.toggle()
                        }
                        .onDisappear {
                            isAnimating.toggle()
                        }
                        
                        Spacer()
                    } //: VSTACK
                }
                .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    RetroChangeColorSchemeView(dismiss: {
        print("Dismiss tapped")
    })
}
