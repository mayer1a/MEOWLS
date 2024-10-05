//
//  PlaceType.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public extension MainBanner {

    enum PlaceType: String, Codable {
        case categories
        case bannersHorizontal = "banners_horizontal"
        case productsCollection = "products_collection"
        case bannersVertical = "banners_vertical"
        case singleBanner = "single_banner"
        case undefined

        public init(from decoder: Decoder) throws {
            self = try PlaceType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .undefined
        }

    }

}
