//
//  City.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.07.2024.
//

import Foundation

public struct City: Codable {

    public let id: String
    public let name: String
    public let location: Location?

}

extension City: Equatable {

    public static func ==(lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }

}

extension City: Comparable {

    public static func <(lhs: City, rhs: City) -> Bool {
        lhs.name.compare(rhs.name) == ComparisonResult.orderedAscending
    }

}
