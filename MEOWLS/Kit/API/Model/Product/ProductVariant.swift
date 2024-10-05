//
//  ProductVariant.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension Product {

    struct ProductVariant: Codable {

        public let id: String
        public let article: String
        public let shortName: String
        public let price: Price?
        public let availabilityInfo: AvailabilityInfo?
        public let badges: [Badge]
        public let propertyValues: [PropertyValue]?

        enum CodingKeys: String, CodingKey {
            case id, article
            case shortName = "short_name"
            case price
            case availabilityInfo = "availability_info"
            case badges
            case propertyValues = "property_values"
        }

    }

}

extension Product.ProductVariant: Equatable {

    public static func == (lhs: Product.ProductVariant, rhs: Product.ProductVariant) -> Bool {
        lhs.id == rhs.id
    }

}
