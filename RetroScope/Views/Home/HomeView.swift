//
//  HomeView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import SwiftUI

struct HomeView: View {
    @State var selectedSymbol: Symbol
    @State private var horoscope: Horoscope?
    @State private var errorMessage: String?
    @State private var initialOpacity: Double = 0.0
    
    @State private var isAnimating: Bool = false
    @State private var isMenuPopoverOpen: Bool = false
    @State private var isErrorRetroAlertOpen: Bool = false
    
    @Binding var isShowingSelectSignView: Bool
    
    private let colors: [Color] = [.vibrantGreen, .amberGlow, .flameOrange, .crimsonBlaze, .royalAmethyst, .azureSky]
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 0) {
                    Spacer()
                    Spacer()
                    
                    ForEach(0..<selectedSymbol.arrayOfName.count, id: \.self) { flip in
                        Text(String(selectedSymbol.arrayOfName[flip]))
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .fontDesign(.monospaced)
                            .foregroundStyle(colorForCharacter(at: flip))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3), {
                            isMenuPopoverOpen.toggle()
                        })
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .fontDesign(.monospaced)
                            .foregroundStyle(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                    })
                    .padding(.leading)
                    .popover(isPresented: $isMenuPopoverOpen,
                             attachmentAnchor: .point(.bottom),
                             arrowEdge: .top,
                             content: {
                        PopOverMenuView(action: { itemTapped in
                            print(itemTapped.title)
                            if itemTapped.title == .changeSign {
                                withAnimation(.easeOut(duration: 0.3), {
                                    isMenuPopoverOpen.toggle()
                                    isShowingSelectSignView.toggle()
                                })
                            }
                            else if itemTapped.title == .reset {
                                //                                withAnimation(.easeOut(duration: 0.3), {
                                //                                    isMenuPopoverOpen.toggle()
                                //                                    withAnimation(.easeInOut(duration: 0.3).delay(0.3), {
                                //                                        showRetroActionOverlay.toggle()
                                //                                    })
                                //                                })
                            }
                        })
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    })
                } //: HSTACK
                .padding()
                
                VStack {
                    Text("Today")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.royalSapphire)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(getFormattedDate())
                        .font(.title2)
                        .fontWeight(.regular)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.royalSapphire)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Rectangle()
                        .frame(height: 4)
                        .foregroundStyle(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                } //: VSTACK
                .padding(.horizontal, 32)
                
                ScrollView(.vertical) {
                    LazyVStack {
                        if let horoscope = horoscope?.horoscope {
                            Text(horoscope)
                                .font(.body)
                                .fontWeight(.light)
                                .fontDesign(.monospaced)
                                .foregroundStyle(.royalSapphire)
                                .multilineTextAlignment(.leading)
                        }
                    } //: LAZYVSTACK
                    .visualEffect { content, proxy in
                        let frame = proxy.frame(in: .scrollView(axis: .vertical))
                        
                        return content
                            .hueRotation(.degrees(frame.origin.y / 10))
                    }
                } //: SCROLLVIEW
                .contentMargins(.horizontal, 32)
                .contentMargins(.top, 10)
                .contentMargins(.bottom, 32)
            } //: VSTACK
            .opacity(initialOpacity)
            .opacity(isAnimating ? 0 : 1)
            .animation(.easeIn(duration: 1.0), value: isAnimating)
            .animation(.easeIn, value: initialOpacity)
            .padding(.vertical)
            .ignoresSafeArea(edges: .bottom)
        } //: ZSTACK
        .background(
            Color.ivoryGlow
                .ignoresSafeArea(.all)
        )
        .overlay {
            if isErrorRetroAlertOpen {
                if let errorMessage = errorMessage {
                    RetroErrorAlertView(error: errorMessage, dismiss: {
                        withAnimation(.easeOut.delay(0.3), {
                            isErrorRetroAlertOpen.toggle()
                        })
                    })
                }
            }
        }
        .overlay {
            if isAnimating {
                RetroLoaderView()
            }
        }
        .onAppear {
            withAnimation(.easeIn, {
                initialOpacity = 0.0
                isAnimating.toggle()
                fetchHoroscopeData()
            })
        }
        .onChange(of: horoscope, {
            if initialOpacity != 1.0 {
                initialOpacity = 1.0
            }
            isAnimating.toggle()
        })
        .onChange(of: errorMessage, {
            withAnimation(.easeInOut(duration: 0.3)) {
                isErrorRetroAlertOpen.toggle()
            }
        })
    }
    
    // Give unique color to each character
    private func colorForCharacter(at index: Int) -> Color {
        colors[index % colors.count]
    }
    
    private func getFormattedDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: currentDate)
    }
    
    private func fetchHoroscopeData() {
        Task { @MainActor in
            do {
                self.horoscope = try await NetworkManager.shared.fetchHoroscope(sign: selectedSymbol.name)
            } catch {
                isAnimating.toggle()
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedSymbol: Symbol = Symbol(
        id: UUID(),
        name: "Aries"
    )
    @Previewable @State var isShowingSelectSignView: Bool = false
    
    HomeView(
        selectedSymbol: selectedSymbol, isShowingSelectSignView: $isShowingSelectSignView
    )
}
