//
//  SuggestionsRequest.swift
//  MEOWLS
//
//  Created by Artem Mayer on 09.08.2024.
//

import Foundation

public struct SuggestionsRequest: Codable {

    public let query: String
    public let cityID: String?
    public let streetID: String?

    enum CodingKeys: String, CodingKey {
        case query
        case cityID = "city_id"
        case streetID = "street_id"
    }

}
