//
//  PaginationInfo.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.07.2024.
//

import Foundation

public struct PaginationInfo: Codable {

    public let page: Int
    public let nextPage: Int?
    public let perPage: Int
    public let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case nextPage = "next_page"
        case perPage = "per_page"
        case totalCount = "total_count"
    }

}

