//
//  CornerRadius.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension MainBanner.UISettings {

    struct CornerRadius: Codable {

        public let topLeft: Int
        public let topRight: Int
        public let bottomLeft: Int
        public let bottomRight: Int

        enum CodingKeys: String, CodingKey {
            case topLeft = "top_left"
            case topRight = "top_right"
            case bottomLeft = "bottom_left"
            case bottomRight = "bottom_right"
        }

    }

}
