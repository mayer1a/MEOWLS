//
// AutocompleteFieldSuggestionCell.swift
// MEOWLS
//
// Created by Artem Mayer on 04.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//  

import SwiftUI

struct AutocompleteFieldSuggestionCell: View {

    let hint: AttributedString
    let tapAction: ParameterClosure<AttributedString>?

    var body: some View {
        Button {
            withAnimation {
                tapAction?(hint)
            }
        } label: {
            Text(hint)
                .padding(.vertical, 10.0)
                .padding(.horizontal, 10.0)
                .frame(maxWidth: .infinity, maxHeight: 40.0, alignment: .leading)
                .background {
                    Color(.backgroundWhite)
                }
        }
        .buttonStyle(HighlightButtonStyle())
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
        .padding(.horizontal, 16)
    }

}
