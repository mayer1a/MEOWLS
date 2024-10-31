//
//  View+onTapBackground.swift
//  MEOWLS
//
//  Created by Artem Mayer on 28.10.2024.
//

import SwiftUI

extension View {

    @ViewBuilder
    private func onTapBackgroundContent(_ action: @escaping VoidClosure) -> some View {
        Color(.backgroundWhite)
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .contentShape(Rectangle())
            .onTapGesture(perform: action)
    }

    func onTapBackground(_ action: @escaping VoidClosure) -> some View {
        background {
            onTapBackgroundContent(action)
        }
    }

}
