//
//  RedirectType.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public extension Redirect {

    enum RedirectType: String, Codable {
        case object
        case productsCollection = "products_collection"
    }

}