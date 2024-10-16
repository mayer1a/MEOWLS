//
//  BannerProductCollectionViewCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import Foundation
import Combine

extension BannerProductCollectionViewCell {

    struct ViewModel {
        let productImageURL: URL
        let productTapClosure: VoidClosure?
        let checkedIsFavoriteClosure: (() -> Bool)?
        let favoriteTapClosure: VoidClosure?
        let favoritePublisher: AnyPublisher<Bool, Never>?
        let badges: [Product.ProductVariant.Badge]?
        let oldPrice: String?
        let specialSale: String?
        let price: String?
        let description: String?

        init(
            productImageURL: URL,
            productTapClosure: VoidClosure?,
            checkedIsFavoriteClosure: (() -> Bool)? = nil,
            favoriteTapClosure: VoidClosure? = nil,
            favoritePublisher: AnyPublisher<Bool, Never>? = nil,
            badges: [Product.ProductVariant.Badge]? = nil,
            oldPrice: String? = nil,
            specialSale: String? = nil,
            price: String? = nil,
            description: String? = nil
        ) {
            self.productImageURL = productImageURL
            self.productTapClosure = productTapClosure
            self.checkedIsFavoriteClosure = checkedIsFavoriteClosure
            self.favoriteTapClosure = favoriteTapClosure
            self.favoritePublisher = favoritePublisher
            self.badges = badges
            self.oldPrice = oldPrice
            self.specialSale = specialSale
            self.price = price
            self.description = description
        }
    }

}
