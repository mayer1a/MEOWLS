//
//  CustomizedPageControl.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI
import Kingfisher

struct CustomizedPageControl: View {

    var numberOfPages: Int
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            HStack(spacing: 6) {
                ForEach(0..<numberOfPages, id: \.self) { page in
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: page == currentPage ? 10 : 4, height: 4)
                        .foregroundStyle(getForegroundColor(for: page))
                        .opacity(page == currentPage ? 1.0 : 0.5)
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 8)
            .background {
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .background(.thinMaterial, in: Rectangle())
                    .frame(height: 14)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            }
            .animation(.default, value: currentPage)
        }
    }

    private func getForegroundColor(for page: Int) -> Color {
        page == currentPage ? Colors.Accent.accentPrimary.suiColor : Colors.Icon.iconWhite.suiColor
    }

}

