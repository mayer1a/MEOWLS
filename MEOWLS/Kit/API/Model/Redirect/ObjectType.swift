//
//  ObjectType.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public extension Redirect {

    enum ObjectType: String, Codable {
        case product = "Product"
        case sale = "Sale"
    }

}
