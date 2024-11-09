//
//  Address.swift
//
//
//  Created by Artem Mayer on 27.07.2024.
//

import Foundation

public struct Address: Codable {

    public let city: City
    public let street: String
    public let house: String
    public let flat: String?
    public let entrance: String?
    public let floor: String?
    public let formatted: String?
    public let location: Location?

    public func format() -> String {
        let granularAddress: [String?] = [street, house, flat]
        return "\(city.name), \(granularAddress.compactMap({$0}).joined(separator: ", "))"
    }

}
