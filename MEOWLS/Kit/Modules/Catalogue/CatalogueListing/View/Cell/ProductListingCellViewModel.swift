//
//  ProductListingCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import Factory

public extension ProductListingCell {

    struct ViewModel: Swift.Identifiable {

        public typealias ID = String

        public var id: String { product.id }

        public let product: Product
        public let name: String
        public let newPrice: String
        public let oldPrice: String?
        public let discount: String?
        public let badges: [Product.ProductVariant.Badge]?
        public let images: [ItemImage]
        public var selectedPage = 0

        public var isFavorite: Bool {
            resolve(\.favoritesService).isFavorite(item: product)
        }

    }

}

extension ProductListingCell.ViewModel {

    func isEqual(_ rhs: Product) -> Bool {
        isFavorite == rhs.starred && product.id == rhs.id
    }

}

extension Array where Element == Product {

    func isEqual(_ rhs: [ProductListingCell.ViewModel]) -> Bool {
        if count == rhs.count {
            return enumerated().allSatisfy { item in
                rhs.indices.contains(item.offset) ? rhs[item.offset].isEqual(item.element) : false
            }
        } else {
            return false
        }
    }

}
