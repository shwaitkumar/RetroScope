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
    @State private var isRetroActionAnimating: Bool = false
    
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
                    .onChange(of: highlightedIndex) {
                        highlightedSymbol = symbols[highlightedIndex ?? 0]
                        flipAngle = flipAngle == .zero ? 360 : .zero
                    }
                    
                    HStack {
                        RetroButtonView(title: "Confirm", color: .vibrantGreen, action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isRetroActionOverlayVisible.toggle()
                            }
                        })
                        .frame(width: geometry.size.width * (UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.5))
                    } //: HSTACK
                    .frame(height: 64)
                    .padding()
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
            .opacity(isAnimating ? 1 : 0)
            .animation(.easeIn(duration: 0.3).delay(0.5), value: isAnimating)
            .ignoresSafeArea(edges: .bottom)
            .overlay(alignment: .center, content: {
                if isRetroActionOverlayVisible {
                    RetroActionView(
                        title: "Confirm \(highlightedSymbol.name)?",
                        confirm: {
                            isRetroActionAnimating.toggle()
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
                            isRetroActionAnimating.toggle()
                            withAnimation(.easeOut(duration: 0.3), {
                                isRetroActionOverlayVisible.toggle()
                            })
                        })
                }
            })
            .onAppear {
                withAnimation(.easeIn.delay(0.5), {
                    isAnimating.toggle()
                })
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
