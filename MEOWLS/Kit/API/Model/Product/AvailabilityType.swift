//
//  AvailabilityType.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public extension Product.ProductVariant.AvailabilityInfo {

    enum AvailabilityType: String, Codable {
        case available = "available"
        case delivery = "delivery"
        case notAvailable = "not_available"
    }

}
