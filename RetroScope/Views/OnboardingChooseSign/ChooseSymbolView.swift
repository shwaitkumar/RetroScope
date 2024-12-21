//
//  ChooseSymbolView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 14/12/24.
//

import SwiftUI

struct ChooseSymbolView: View {
    @AppStorage("storedSymbol") var storedSymbol: String?
    
    @State private var highlightedSymbol: Symbol = Symbol.symbols.first!
    @State private var highlightedIndex: Int? = 0
    
    @State private var isAnimating: Bool = false
    @State private var flipAngle: Double = .zero
    @State private var isRetroActionOverlayVisible: Bool = false
    
    @Binding var selectedSymbol: Symbol?
    
    private let symbols = Symbol.symbols
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack(spacing: 0) {
                        ForEach(0..<highlightedSymbol.arrayOfName.count, id: \.self) { flip in
                            Text(String(highlightedSymbol.arrayOfName[flip]))
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .fontDesign(.monospaced)
                                .foregroundStyle(colorForCharacter(at: flip))
                                .rotation3DEffect(.degrees(flipAngle), axis: (x: 0, y: 1, z: 0))
                                .animation(.easeInOut.delay(Double(flip) * 0.1), value: flipAngle)
                        }
                    } //: HSTACK
                    .padding()
                    .scaleEffect(isAnimating ? 1 : 1.5)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeInOut(duration: 0.8), value: isAnimating)
                    
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            ForEach(symbols.indices, id: \.self) { index in
                                Image(symbols[index].name)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .frame(width: geometry.size.width, height:  geometry.size.width * (UIDevice.current.userInterfaceIdiom == .phone ? 1.0 : 0.8))
                                    .scrollTransition(axis: .horizontal) { content, phase in
                                        content
                                            .rotationEffect(.degrees(phase.value * 360))
                                            .scaleEffect(phase.isIdentity ? 1 : 0.3, anchor: .center)
                                            .offset(y: phase.isIdentity ? 0 : 80)
                                    }
                            }
                        } //: LAZYHSTACK
                        .scrollTargetLayout()
                    } //: SCROLLVIEW
                    .frame(width: geometry.size.width, height: geometry.size.width * (UIDevice.current.userInterfaceIdiom == .phone ? 1.0 : 0.8))
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $highlightedIndex)
                    .scrollIndicators(.hidden)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0)
                    .blur(radius: isAnimating ? 0 : 10)
                    .animation(.easeInOut(duration: 0.4).delay(0.3), value: isAnimating)
                    .onChange(of: highlightedIndex) {
                        highlightedSymbol = symbols[highlightedIndex ?? 0]
                        flipAngle = flipAngle == .zero ? 360 : .zero
                    }
                    
                    HStack {
                        RetroButtonView(title: "Confirm", color: .vibrantGreen, action: {
                            withAnimation(.easeIn(duration: 0.3)) {
                                isRetroActionOverlayVisible.toggle()
                            }
                        })
                        .frame(width: geometry.size.width * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.5))
                    } //: HSTACK
                    .frame(height: 64)
                    .padding()
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : geometry.size.height / 2)
                    .blur(radius: isAnimating ? 0 : 10)
                    .animation(.easeInOut(duration: 0.8).delay(0.3), value: isAnimating)
                    .visualEffect { content, proxy in
                        content
                            .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y / 20))
                    }
                    
                    Spacer()
                } //: VSTACK
                .padding(.vertical)
            } //: ZSTACK
            .background(
                Color.ivoryGlow
            )
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .center, content: {
                if isRetroActionOverlayVisible {
                    RetroActionView(
                        title: "Confirm \(highlightedSymbol.name)?",
                        confirm: {
                            withAnimation(.easeOut(duration: 0.3), {
                                isRetroActionOverlayVisible.toggle()
                                // Store info here and call api
                                if let encodedSymbol = try? JSONEncoder().encode(highlightedSymbol) {
                                    storedSymbol = String(data: encodedSymbol, encoding: .utf8)
                                    selectedSymbol = highlightedSymbol
                                }
                            })
                        },
                        dismiss: {
                            withAnimation(.easeOut(duration: 0.3), {
                                isRetroActionOverlayVisible.toggle()
                            })
                        })
                }
            })
            .onAppear {
                isAnimating.toggle()
            }
        }
    }
    
    // Give unique color to each character
    private func colorForCharacter(at index: Int) -> Color {
        Color.retroColors[index % Color.retroColors.count]
    }
}

#Preview {
    @Previewable @State var selectedSymbol : Symbol? = Symbol(
        id: UUID(),
        name: "Aries"
    )
    
    ChooseSymbolView(selectedSymbol: $selectedSymbol)
}
