//
//  RetroLoaderView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import SwiftUI

struct RetroLoaderView: View {
    @State private var loadingDots = ""
    @State private var visibleBoxCount = 0
    @State private var filledColorsCount = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("LOADING...")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.royalSapphire)
                    .fontDesign(.monospaced)
                
                // Rectangle with Growing Color Boxes
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.royalSapphire, lineWidth: 2)
                    
                    // Foreground animated boxes
                    HStack(spacing: 4) {
                        ForEach(0..<Color.retroColors.count, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.retroColors[index])
                                .opacity(filledColorsCount > index ? 1 : 0) // Opacity logic
                                .animation(.linear(duration: 0.1), value: filledColorsCount)
                                .padding(.vertical, 4)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to left
                    .padding(.horizontal, 4)
                    .onAppear {
                        animateBoxes()
                    }
                } //: ZSTACK
                .frame(width: geometry.size.width / 2, height: geometry.size.width / 10)
            } //: VSTACK
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(
                Color.ivoryGlow
                    .ignoresSafeArea(.all)
            )
        }
    }
    
    private func animateBoxes() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if filledColorsCount == Color.retroColors.count {
                filledColorsCount = 0 // Reset after all boxes are visible
            } else {
                filledColorsCount += 1
            }
        }
    }
}

#Preview {
    RetroLoaderView()
}
