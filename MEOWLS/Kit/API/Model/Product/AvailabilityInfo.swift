//
//  AvailabilityInfo.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension Product.ProductVariant {

    struct AvailabilityInfo: Codable {

        public let type: AvailabilityType
        public let deliveryDuration: Int?
        public let count: Int

        enum CodingKeys: String, CodingKey {
            case type
            case deliveryDuration = "delivery_duration"
            case count
        }

    }

}
