//
//  EmployeeRole.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.10.2024.
//

import Foundation

public enum EmployeeRole: String, Codable {
    case merchandiser = "MERCHANDISER"
    case courier = "COURIER"
    case unknown
}

public extension EmployeeRole {

    init(from decoder: Decoder) throws {
        self = try EmployeeRole(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
