//
//  ProductsSet.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension Redirect {

    struct ProductsSet: Codable {
        
        public let name: String
        public let category: Category?
        public let query: String?

    }

}
