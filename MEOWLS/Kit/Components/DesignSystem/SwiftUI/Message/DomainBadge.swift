//
//  DomainBadge.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI

struct DomainBadge: View {

    private let configuration: BadgeConfiguration

    @State private var cornerRadius: CGFloat = 0
    @State private var text: String

    init(_ text: String, with configuration: BadgeConfiguration) {
        self.text = text
        self.configuration = configuration
    }

    var body: some View {
        Text(text)
            .frame(height: configuration.size.textHeight)
            .font(configuration.size.font.asFont)
            .foregroundStyle(configuration.color.foregroundColor.asColor)
            .padding(.horizontal, configuration.size.horizontalPadding)
            .padding(.vertical, 2)
            .background {
                GeometryReader { geometry in
                    configuration.color.backgroundColor.asColor
                        .onAppear {
                            cornerRadius = geometry.size.height * configuration.type.rawValue
                        }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

}

#if DEBUG

#Preview {
    VStack( spacing: 16) {
        HStack(alignment: .center, spacing: 16) {
            DomainBadge("-40%", with: .init(size: .small, type: .square, color: .red(opaque: true)))
            DomainBadge("-40%", with: .init(size: .big, type: .square, color: .red(opaque: true)))
            DomainBadge("-40%", with: .init(size: .small, type: .round, color: .red(opaque: true)))
            DomainBadge("-40%", with: .init(size: .big, type: .round, color: .red(opaque: true)))
            DomainBadge("-40%", with: .init(size: .small, type: .square, color: .red(opaque: false)))
            DomainBadge("-40%", with: .init(size: .small, type: .round, color: .red(opaque: false)))
            DomainBadge("-40%", with: .init(size: .big, type: .square, color: .red(opaque: false)))
            DomainBadge("-40%", with: .init(size: .big, type: .round, color: .red(opaque: false)))
        }
        HStack(alignment: .center, spacing: 16) {
            DomainBadge("-40%", with: .init(size: .small, type: .square, color: .green(opaque: true)))
            DomainBadge("-40%", with: .init(size: .big, type: .square, color: .green(opaque: true)))
            DomainBadge("-40%", with: .init(size: .small, type: .round, color: .green(opaque: true)))
            DomainBadge("-40%", with: .init(size: .big, type: .round, color: .green(opaque: true)))
            DomainBadge("-40%", with: .init(size: .small, type: .square, color: .green(opaque: false)))
            DomainBadge("-40%", with: .init(size: .small, type: .round, color: .green(opaque: false)))
            DomainBadge("-40%", with: .init(size: .big, type: .square, color: .green(opaque: false)))
            DomainBadge("-40%", with: .init(size: .big, type: .round, color: .green(opaque: false)))
        }
        HStack(alignment: .center, spacing: 16) {
            DomainBadge("-40%", with: .init(size: .small, type: .square, color: .black(opaque: true)))
            DomainBadge("-40%", with: .init(size: .big, type: .square, color: .black(opaque: true)))
            DomainBadge("-40%", with: .init(size: .small, type: .round, color: .black(opaque: true)))
            DomainBadge("-40%", with: .init(size: .big, type: .round, color: .black(opaque: true)))
            DomainBadge("-40%", with: .init(size: .small, type: .square, color: .black(opaque: false)))
            DomainBadge("-40%", with: .init(size: .small, type: .round, color: .black(opaque: false)))
            DomainBadge("-40%", with: .init(size: .big, type: .square, color: .black(opaque: false)))
            DomainBadge("-40%", with: .init(size: .big, type: .round, color: .black(opaque: false)))
        }
    }
    .padding()
}

#endif

