//
//  NavigationShadowVStack.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI

struct NavigationShadowVStack<Content: View>: View {

    var content: () -> Content

    @State private var alignment: HorizontalAlignment
    @State private var spacing: CGFloat
    @Binding private var enableShadow: Bool
    @State private var defaultMidY: CGFloat = -1

    init(alignment: HorizontalAlignment = .center,
         spacing: CGFloat = 0,
         enableShadow: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content) {

        self.alignment = alignment
        self.spacing = spacing
        self._enableShadow = enableShadow
        self.content = content
    }

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            GeometryReader { geometry in
                Rectangle()
                    .frame(width: 0, height: 0)
                    .onAppear {
                        if defaultMidY == -1 {
                            defaultMidY = geometry.frame(in: .global).midY
                        }
                    }
                    .onChange(of: geometry.frame(in: .global).midY) { midY in
                        withAnimation(.linear(duration: 0.1)) {
                            enableShadow = midY < defaultMidY
                        }
                    }
            }
            .frame(width: 0, height: 0)

            content()
        }
    }

}
