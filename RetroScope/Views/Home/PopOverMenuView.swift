//
//  PopOverMenuView.swift
//  RetroScope
//
//  Created by Shwait Kumar on 19/12/24.
//

import SwiftUI

struct PopOverMenuView: View {
    let menuItems = PopOverMenuItem.popOverMenuItems
    let action: (PopOverMenuItem) -> Void
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                ForEach(menuItems) { item in
                    PopOverMenuItemView(menuItem: item, action: {
                        action(item)
                    })
                }
                .visualEffect { content, proxy in
                    content
                        .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y / 10))
                }
            } //: SCROLLVIEW
        } //: ZSTACK
    }
}

struct PopOverMenuItemView: View {
    let menuItem: PopOverMenuItem
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Text(menuItem.title.rawValue)
                    .fontWeight(.medium)
                    .fontDesign(.monospaced)
                    .foregroundStyle(menuItem.color)
            } //: HSTACK
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                Color.amberGlow.opacity(0.1)
            )
        })
    }
}

#Preview {
    PopOverMenuView(action: { _ in
        print("Button tapped")
    })
}
