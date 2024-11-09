//
//  NavigationBarShadowModifier.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI

public struct NavigationBarShadowModifier: ViewModifier {

    @Binding var enableShadow: Bool

    public func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color.white
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                        .shadow(color: shadowColor, radius: 12, x: 0, y: 0)
                    Spacer()
                }
            }
        }
    }

    private var shadowColor: Color {
        enableShadow ? Colors.Shadow.shadowSmall.suiColor : .clear
    }

}

public extension View {

    func navigationBarShadow(enable: Binding<Bool>) -> some View {
        modifier(NavigationBarShadowModifier(enableShadow: enable))
    }

}
