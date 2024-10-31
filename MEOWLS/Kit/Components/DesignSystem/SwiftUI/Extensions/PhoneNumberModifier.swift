//
//  PhoneNumberModifier.swift
//  MEOWLS
//
//  Created by Artem Mayer on 28.10.2024.
//

import SwiftUI
import Combine
import PhoneNumberKit

struct PhoneNumberModifier: ViewModifier {

    weak var formatter: PartialFormatter?
    @Binding var field: String
    @State private var lastText: String = ""
    @State private var isFullNumber: Bool = false

    func body(content: Content) -> some View {
        content
            .onReceive(Just(field)) { text in
                guard let formatter, lastText != text else {
                    return
                }

                if isFullNumber, text.count > lastText.count {
                    field = lastText
                    return
                }

                let updatedField = formatter.formatPartial(text)
                    .replacingOccurrences(of: "-", with: " ")

                isFullNumber = updatedField.count == lastText.count && !updatedField.isEmpty

                field = updatedField
                lastText = updatedField
            }
    }

}

extension View {

    func phoneFormattedText(_ field: Binding<String>, formatter: PartialFormatter?) -> some View {
        modifier(PhoneNumberModifier(formatter: formatter, field: field))
    }

}
