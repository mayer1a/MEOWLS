//
//  Category.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public final class Category: Codable {

    public let id: String
    public let code: String
    public let name: String
    public let parent: Category?
    public let products: [Product]?
    public let hasChildren: Bool
    public let image: ItemImage?

    enum CodingKeys: String, CodingKey {
        case id, code, name, parent, products
        case hasChildren = "has_children"
        case image
    }

}
