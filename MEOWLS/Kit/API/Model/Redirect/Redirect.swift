//
//  Redirect.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public struct Redirect: Codable {

    public let redirectType: RedirectType
    public let objectID: String?
    public let objectType: ObjectType?
    public let productsSet: ProductsSet?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case redirectType = "type"
        case objectID = "object_id"
        case objectType = "object_type"
        case productsSet = "products_set"
        case url
    }

}
