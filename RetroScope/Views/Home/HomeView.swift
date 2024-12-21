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
    @State private var isChangeColorSchemeViewOpen: Bool = false
    @State private var isErrorRetroAlertOpen: Bool = false
    
    @Binding var isShowingSelectSignView: Bool
    
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
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        isMenuPopoverOpen.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .fontDesign(.monospaced)
                            .foregroundStyle(LinearGradient(colors: Color.retroColors, startPoint: .top, endPoint: .bottom))
                    })
                    .disabled(isMenuPopoverOpen)
                    .padding(.leading)
                    .popover(isPresented: $isMenuPopoverOpen,
                             attachmentAnchor: .point(.bottom),
                             arrowEdge: .top,
                             content: {
                        PopOverMenuView(action: { itemTapped in
                            print(itemTapped.title)
                            if itemTapped.title == .changeSign {
                                isMenuPopoverOpen.toggle()
                                withAnimation(.easeIn) {
                                    isShowingSelectSignView.toggle()
                                }
                            }
                            else if itemTapped.title == .switchColorScheme {
                                isMenuPopoverOpen.toggle()
                                withAnimation(.easeIn(duration: 0.3)) {
                                    isChangeColorSchemeViewOpen.toggle()
                                }
                            }
                        })
                        .padding()
                        .presentationCompactAdaptation(.popover)
                    })
                } //: HSTACK
                .opacity(initialOpacity)
                .opacity(isAnimating ? 0 : 1)
                .animation(.easeInOut(duration: 0.8), value: isAnimating)
                .animation(.easeIn, value: initialOpacity)
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
                        .foregroundStyle(LinearGradient(colors: Color.retroColors, startPoint: .leading, endPoint: .trailing))
                        .scaleEffect(isAnimating ? 0 : 1, anchor: .center)
                        .scaleEffect(initialOpacity == 0 ? 0 : 1, anchor: .center)
                        .animation(.easeInOut(duration: 0.6).delay(0.3), value: isAnimating)
                        .animation(.easeInOut, value: initialOpacity)
                } //: VSTACK
                .padding(.horizontal, 32)
                .opacity(initialOpacity)
                .opacity(isAnimating ? 0 : 1)
                .animation(.easeInOut(duration: 0.3).delay(0.3), value: isAnimating)
                .animation(.easeIn, value: initialOpacity)
                
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
                            .hueRotation(.degrees(frame.origin.y / 4))
                    }
                } //: SCROLLVIEW
                .scrollIndicators(.hidden)
                .contentMargins(.horizontal, 32)
                .contentMargins(.top, 10)
                .contentMargins(.bottom, 32)
                .opacity(initialOpacity)
                .opacity(isAnimating ? 0 : 1)
                .animation(.bouncy(duration: 1.0).delay(1.0), value: isAnimating)
                .animation(.easeIn, value: initialOpacity)
            } //: VSTACK
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
                        withAnimation(.easeOut(duration: 0.3), {
                            isErrorRetroAlertOpen.toggle()
                        })
                    })
                }
            }
            else if isChangeColorSchemeViewOpen {
                RetroChangeColorSchemeView(dismiss: {
                    withAnimation(.easeOut(duration: 0.3), {
                        isChangeColorSchemeViewOpen.toggle()
                    })
                })
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
            withAnimation(.easeOut(duration: 0.3)) {
                isErrorRetroAlertOpen.toggle()
            }
        })
    }
    
    // Give unique color to each character
    private func colorForCharacter(at index: Int) -> Color {
        Color.retroColors[index % Color.retroColors.count]
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
                // Uncomment below line for testing as you might exceed rate limit while editing code and preview calling for API again and again.
//                self.horoscope = Horoscope(
//                    sign: "Aries",
//                    horoscope: "Retro Orange has the hex code #C67C38. The equivalent RGB values are (198, 124, 56), which means it is composed of 52% red, 33% green and 15% blue. The CMYK color codes, used in printers, are C:0 M:37 Y:72 K:22. In the HSV/HSB scale, Retro Orange has a hue of 29°, 72% saturation and a brightness value of 78%.\nDetails of other color codes including equivalent web safe and HTML & CSS colors are given in the table below. Also listed are the closest Pantone® (PMS) and RAL colors.\nRetro Orange is not part of the web colors list and, therefore, cannot be used by name in HTML and CSS code. The best way to apply the color to a web page is to put in its hex, RGB or HSL values. Please also note that the retro orange CMYK numbers mentioned on this page are only approximations and have been calculated from the hex code using well-known formulae."
//                )
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
