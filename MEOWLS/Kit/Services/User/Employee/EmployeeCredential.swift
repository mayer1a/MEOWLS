//
//  EmployeeCredential.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.10.2024.
//

import Foundation

public struct EmployeeCredential: Codable {

    public let id: String?
    public let username: String?
    public let name: String?
    public let patronymic: String?
    public let surname: String?
    public let avatar: String?

    public let phone: String?
    public let email: String?

    public let position: String?
    public let regions: [String]?

    public let roles: [EmployeeRole]?

    public let company: EmployeeCompanyInfo?

    public enum CodingKeys: String, CodingKey {
        case name, patronymic, surname
        case phone, email, username, position, avatar, regions, roles, id, company
    }

}

public struct EmployeeCompanyInfo: Codable {

    public let id: String?
    public let name: String?
    public let contacts: EmployeeCompanyContacts?

    public enum CodingKeys: String, CodingKey {
        case id, name, contacts
    }

}

public struct EmployeeCompanyContacts: Codable {

    public let techSupportPhone: String?

    public enum CodingKeys: String, CodingKey {
        case techSupportPhone = "tech_support_phone"
    }

}
