//
//  ViewShadowModifier.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.10.2024.
//

import SwiftUI

public struct ViewShadowModifier: ViewModifier {

    @Binding public var enableShadow: Bool
    @State private var contentHeight: CGFloat = 0

    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .background {
                    GeometryReader { proxy in
                        Color.white
                            .onAppear {
                                contentHeight = proxy.size.height
                            }
                    }
                }
                .zIndex(1)

            if enableShadow {
                Color.white
                    .frame(height: contentHeight)
                    .edgesIgnoringSafeArea(.top)
                    .shadow(color: shadowColor, radius: 12, x: 0, y: 12)
                    .offset(y: 12)
            }
        }
    }

    private var shadowColor: Color {
        enableShadow ? Color(.shadowSmall) : .clear
    }
    
}

public extension View {

    func viewShadow(enable: Binding<Bool>) -> some View {
        modifier(ViewShadowModifier(enableShadow: enable))
    }

}
