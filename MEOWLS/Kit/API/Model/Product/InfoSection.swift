//
//  InfoSection.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension Product {

    struct InfoSection: Codable, Equatable {
        public let title: String
        public let type: InfoSectionType
        public let text: String
        public let link: String?
    }

}
