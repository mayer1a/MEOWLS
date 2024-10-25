//
//  ProductCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import Foundation
import Combine

public extension ProductCell {

    struct ViewModel {

        public let cellViewType: CellViewType
        public let isTransparent: Bool
        public let isBordered: Bool

        public let images: [ItemImage]
        public let isVariablePrice: Bool
        public let newPrice: NSAttributedString?
        public let oldPrice: NSAttributedString?
        public let discount: String?
        public let badges: [Product.ProductVariant.Badge]?
        public let productName: String

        public let favoritesPublisher: AnyPublisher<Bool, Never>?
        public let favoritesTapHandler: VoidClosure?
        public let checkedIsFavoriteClosure: (() -> Bool)?
        public let cartTapHandler: VoidClosure?
        public let productTapHandler: VoidClosure?

    }

}

public extension ProductCell.ViewModel {

    enum CellViewType: Equatable {
        case expanded
        case compact
    }

}
