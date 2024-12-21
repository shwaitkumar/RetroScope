//
//  RetroChangeColorSchemeView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 21/12/24.
//

import SwiftUI

struct RetroChangeColorSchemeView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    let dismiss: () -> Void
    
    private let colors: [Color] = [.vibrantGreen, .amberGlow, .flameOrange, .crimsonBlaze, .royalAmethyst, .azureSky]
    
    var body: some View {
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
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut.delay(0.3), {
                                        isDarkMode.toggle()
                                    })
                                }, label: {
                                    HStack {
                                        Image(systemName: isDarkMode ? "sun.max" : "sun.max.fill")
                                            .foregroundStyle(Color.amberGlow)
                                        
                                        Text("Light")
                                            .foregroundStyle(.royalSapphire)
                                    } //: HSTACK
                                    .font(.subheadline)
                                    .fontWeight(isDarkMode ? .regular : .bold)
                                    .fontDesign(.monospaced)
                                    .padding()
                                })
                                
                                Button(action: {
                                    withAnimation(.easeInOut.delay(0.3), {
                                        isDarkMode.toggle()
                                    })
                                }, label: {
                                    HStack {
                                        Image(systemName: isDarkMode ? "moon.stars.fill" : "moon.stars")
                                            .foregroundStyle(Color.azureSky)
                                        
                                        Text("Dark")
                                            .foregroundStyle(.royalSapphire)
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
                                    .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y / 10))
                            }
                        } //: VSTACK
                        .padding(.horizontal)
                        .padding()
                    } //: ZSTACK
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    
                    Rectangle()
                        .fill(.clear)
                } //: VSTACK
            }
            .ignoresSafeArea(.all)
            .onAppear {
                print("Current Color Scheme: \(isDarkMode)")
            }
    }
}

#Preview {
    RetroChangeColorSchemeView(dismiss: {
        print("Dismiss tapped")
    })
}
