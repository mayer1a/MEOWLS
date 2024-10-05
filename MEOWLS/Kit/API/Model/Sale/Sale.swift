//
//  Sale.swift
//
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public struct Sale: Codable {

    public let id: UUID
    public let code: String
    public let saleType: SaleType
    public let title: String
    public let image: ItemImage?
    public let startDate: Date?
    public let endDate: Date?
    public let disclaimer: String
    public let products: [Product]?

    enum CodingKeys: String, CodingKey {
        case id, code
        case saleType = "sale_type"
        case title, image
        case startDate = "start_date"
        case endDate = "end_date"
        case disclaimer, products
    }

}

public extension Sale {

    var formattedSchedule: String? {
        Date.formattedSchedule(sinceDate: startDate, untilDate: endDate)
    }

    var formattedUntilSchedule: String? {
        if let endDate {
            return String(format: Strings.Promotion.until, endDate.briefYearDate)
        }
        return nil
    }

}
