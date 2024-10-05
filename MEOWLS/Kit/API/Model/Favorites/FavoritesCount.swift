//
//  FavoritesCount.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public struct FavoritesCount: Codable {

    public let count: Int

    enum CodingKeys: String, CodingKey {
        case count = "favorites_products_count"
    }

}
