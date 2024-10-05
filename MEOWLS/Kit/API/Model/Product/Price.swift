//
//  Price.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension Product.ProductVariant {

    struct Price: Codable {

        public var originalPrice: Double
        public let discount: Double?
        public var price: Double

        enum CodingKeys: String, CodingKey {
            case originalPrice = "original_price"
            case discount, price
        }

    }

}
