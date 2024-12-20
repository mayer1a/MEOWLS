//
//  UISettings.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension MainBanner {

    struct UISettings: Codable {
        public let backgroundColor: HEXColor?
        public let spasings: Spacing?
        public let cornerRadiuses: CornerRadius?
        public let autoSlidingTimeout: Int?
        public let metrics: [Metric]?

        enum CodingKeys: String, CodingKey {
            case backgroundColor = "background_color"
            case spasings
            case cornerRadiuses = "corner_radiuses"
            case autoSlidingTimeout = "auto_sliding_timeout"
            case metrics
        }

    }

}
