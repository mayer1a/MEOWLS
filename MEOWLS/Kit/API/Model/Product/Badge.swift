//
//  Badge.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension Product.ProductVariant {

    struct Badge: Codable {

        public let title: String
        public let text: String?
        public let backgroundColor: HEXColor
        public let tintColor: HEXColor

        enum CodingKeys: String, CodingKey {
            case title, text
            case backgroundColor = "background_color"
            case tintColor = "tint_color"
        }

    }

}
