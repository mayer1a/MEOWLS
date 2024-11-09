//
//  ProductProperty.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension Product {

    struct ProductProperty: Codable, Equatable {
        public let id: String
        public let name: String
        public let code: String
        public let selectable: Bool
    }

}
