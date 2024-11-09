//
//  ProductsListingView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI

public struct ProductsListingView: View {

    @Binding var isShortMode: Bool
    @Binding var items: [ProductListingCell.ViewModel]
    @Binding var cartProducts: [String]
    @Binding var enableShadow: Bool
    @Binding var isLoadingMore: Bool
    @State var canTransparentCell: Bool = false
    var ratioMultiplier: Double

    var favoriteHandler: ((Product) -> Void)?
    var cartAction: ((Product) -> Void)?
    var fetchMoreContent: VoidClosure?
    var onTapHandler: ((Product) -> Void)?

    private let columns: [GridItem] = {
        Array(repeating: .init(.flexible(minimum: 120), spacing: 17),
              count: 2)
    }()

    public var body: some View {
        ScrollView {
            NavigationShadowVStack(alignment: .center, spacing: 17, enableShadow: $enableShadow) {
                LazyVGrid(columns: columns, spacing: 17) {
                    ForEach(items, id: \.id) { item in
                        ProductListingCell(isShortMode: $isShortMode,
                                           model: item,
                                           isInACart: cartProducts.contains(item.product.id),
                                           ratioMultiplier: ratioMultiplier,
                                           favoriteHandler: favoriteHandler,
                                           cartAction: cartAction)
                        .onAppear {
                            if items.last?.id == item.id {
                                fetchMoreContent?()
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onTapHandler?(item.product)
                        }
                        .opacity(canTransparentCell && !item.isFavorite ? 0.2 : 1)
                        .animation(.default, value: canTransparentCell && !item.isFavorite)
                    }
                }

                if isLoadingMore {
                    CustomCircularProgressView(size: 32)
                }
            }
            .padding(.all, 16)
        }
    }

}
