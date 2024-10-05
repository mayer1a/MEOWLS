//
//  MainBanner.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public struct MainBanner: Codable {

    public let id: String
    public let title: String?
    public let placeType: PlaceType
    public let redirect: Redirect?
    public let uiSettings: UISettings?
    public let categories: [Category]?
    public let banners: [MainBanner]?
    public var products: [Product]?
    public let image: ItemImage?

    enum CodingKeys: String, CodingKey {
        case id, title
        case placeType = "place_type"
        case redirect
        case uiSettings = "ui_settings"
        case categories, banners, products, image
    }

}
