//
//  StrikethroughPriceView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI

struct StrikethroughPriceView: View {

    var oldPrice: String
    var discount: String?

    var body: some View {
        HStack(spacing: 6) {
            Text(oldPrice)
                .strikethrough()
                .foregroundStyle(Color(.textSecondary))
                .font(UIFont.systemFont(ofSize: 14, weight: .medium).asFont)

            if let discount {
                DomainBadge(discount,
                            with: .init(type: .square,  color: .red(opaque: false)))
            }
        }
    }

}
