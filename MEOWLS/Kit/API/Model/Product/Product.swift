//
//  Product.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation
import Factory

public struct Product: Codable {

    public let id: String
    public let name: String
    public let code: String
    /// Only one image if not for detailed product
    public let images: [ItemImage]
    public let allowQuickBuy: Bool
    public let variants: [ProductVariant]
    /// Only for detailed product
    public let productProperties: [ProductProperty]?
    public let defaultVariantArticle: String?
    /// Only for detailed product if url exists
    public let deliveryConditionsURL: String?
    /// Only for detailed product
    public let sections: [InfoSection]?

    enum CodingKeys: String, CodingKey {
        case id, name, code, images
        case allowQuickBuy = "allow_quick_buy"
        case variants
        case productProperties = "properties"
        case defaultVariantArticle = "default_variant_article"
        case deliveryConditionsURL = "delivery_conditions_url"
        case sections
    }

}

extension Product: Equatable, Identifiable {

    public var identifier: String {
        id
    }

}

extension Product: Favoritable {

    public var starred: Bool? {
        #if Store
            resolve(\.user).favoriteProducts?.contains(identifier) ?? false
        #else
            nil
        #endif
    }

}

public extension Product {

    var isVariablePrice: Bool {
        variants.count > 1
    }

    var defaultVariant: ProductVariant? {
        guard let defaultVariantArticle else {
            return variants.first
        }

        return variants.first(where: { $0.article == defaultVariantArticle })
    }

    func discountFormatted(for variant: ProductVariant? = nil) -> String? {
        guard
            let variant = variant ?? variants.first(where: { $0.article == defaultVariantArticle }),
            let discount = variant.price?.discount,
            discount > 0
        else {
            return nil
        }

        return "-\(discount)%"
    }

    func newPrice(for variant: ProductVariant? = nil) -> Double? {
        guard
            let variant = variant ?? variants.first(where: { $0.article == defaultVariantArticle }),
            let price = variant.price?.price
        else {
            return nil
        }

        return price
    }

    func oldPrice(for variant: ProductVariant? = nil) -> Double? {
        guard
            let variant = variant ?? variants.first(where: { $0.article == defaultVariantArticle }),
            let price = variant.price
        else {
            return nil
        }

        let oldPrice = price.originalPrice
        let isOldPriceGreaterThanNew = (oldPrice.asDecimal) > (price.price.asDecimal)
        return isOldPriceGreaterThanNew ? oldPrice : nil
    }

}
