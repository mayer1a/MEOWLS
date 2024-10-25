//
//  CustomCircularProgressView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI

public struct CustomCircularProgressView: View {

    public init(size: CGFloat = 48) {
        self.size = size
    }

    private let size: CGFloat
    @State private var anim: Animation? = .linear(duration: 1).repeatForever(autoreverses: false)
    @State private var showAnimation: Bool = false

    public var body: some View {
        VStack(alignment: .center) {
            Spacer()

            loader

            Spacer()
        }
    }

}

private extension CustomCircularProgressView {

    var loader: some View {
        Image(.loader)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .rotationEffect(.degrees(showAnimation ? 360 : 0))
            .animation(anim, value: showAnimation)
            .onAppear {
                DispatchQueue.main.async {
                    showAnimation = true
                }
            }
            .onDisappear {
                DispatchQueue.main.async {
                    showAnimation = false
                }
            }
        .frame(width: size, height: size)
    }

}

public struct ViewLoadingModifier: ViewModifier {

    public let isLoading: Bool
    public let isBlocking: Bool

    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading && isBlocking)

            if isLoading {
                CustomCircularProgressView()
                    .ignoresSafeArea(.keyboard)
            }
        }
    }

}

public extension View {

    func showLoader(_ isLoading: Bool, isBlocking: Bool = true) -> some View {
        modifier(ViewLoadingModifier(isLoading: isLoading, isBlocking: isBlocking))
    }

}

