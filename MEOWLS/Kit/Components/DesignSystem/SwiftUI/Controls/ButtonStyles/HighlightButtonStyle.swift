//
// HighlightButtonStyle.swift
// MEOWLS
//
// Created by Artem Mayer on 04.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//  

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(content: { configuration.isPressed ? Colors.Background.backgroundOverlayLight.suiColor : .clear })
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
    }

}
