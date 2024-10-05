//
//  PropertyValue.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension Product.ProductVariant {

    struct PropertyValue: Codable {

        public let id: String
        public let propertyID: UUID
        public let value: String

        enum CodingKeys: String, CodingKey {
            case id
            case propertyID = "property_id"
            case value
        }

    }

}
