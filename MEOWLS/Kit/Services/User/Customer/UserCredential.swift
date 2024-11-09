//
//  UserCredential.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public struct UserCredential: Codable {

    public let id: String?
    public let surname: String?
    public let name: String?
    public let patronymic: String?
    public let birthday: Date?
    public let gender: Gender?
    public let email: String?
    public let phone: String?
    public let authentication: User.Authentication?
    public let favoriteProducts: [String]?

    public var fio: String {
        [surname, name, patronymic]
            .compactMap({ $0?.isEmpty ?? true ? nil : $0 })
            .joined(separator: " ")
    }

    public init(
        id: String? = nil,
        surname: String?,
        name: String?,
        patronymic: String?,
        birthday: Date?,
        gender: Gender?,
        email: String?,
        phone: String?,
        authentication: User.Authentication? = nil,
        favoriteProducts: [String]? = nil
    ) {
        self.id = id
        self.surname = surname
        self.name = name
        self.patronymic = patronymic
        self.birthday = birthday
        self.gender = gender
        self.email = email
        self.phone = phone
        self.authentication = authentication
        self.favoriteProducts = favoriteProducts
    }

    public init(from credentials: User.Update) {
        id = nil
        surname = credentials.surname
        name = credentials.name
        patronymic = credentials.patronymic
        birthday = credentials.birthday?.toDate
        gender = credentials.gender
        email = credentials.email
        phone = credentials.phone
        authentication = nil
        favoriteProducts = nil
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case id, birthday, gender, email, phone, surname, name, patronymic, authentication
        case favoriteProducts = "favorite_items"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(surname, forKey: .surname)
        try container.encode(name, forKey: .name)
        try container.encode(patronymic, forKey: .patronymic)
        let formattedBirthday = birthday.map({ $0.toClearISO8601 })
        try container.encode(formattedBirthday, forKey: .birthday)
        try container.encode(gender?.description ?? "", forKey: .gender)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(favoriteProducts, forKey: .favoriteProducts)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(String?.self, forKey: .id)
        surname = try? container.decode(String?.self, forKey: .surname)
        name = try? container.decode(String?.self, forKey: .name)
        patronymic = try? container.decode(String?.self, forKey: .patronymic)
        if let birthdayString = try? container.decode(String.self, forKey: .birthday) {
            birthday = birthdayString.toDate
        } else {
            birthday = nil
        }
        let genderString = try? container.decode(String?.self, forKey: .gender)
        gender = Gender(with: genderString)
        email = try? container.decode(String?.self, forKey: .email)
        phone = try? container.decode(String?.self, forKey: .phone)
        authentication = try? container.decode(User.Authentication?.self, forKey: .authentication)
        favoriteProducts = try? container.decode([String]?.self, forKey: .favoriteProducts)
    }

}
