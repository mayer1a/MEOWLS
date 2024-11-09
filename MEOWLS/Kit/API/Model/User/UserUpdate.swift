//
//  UserUpdate.swift
//
//
//  Created by Artem Mayer on 28.06.2024.
//

import Foundation

public extension User {

    struct Update: Codable {

        public let surname: String?
        public let name: String?
        public let patronymic: String?
        public let birthday: String?
        public let gender: UserCredential.Gender?
        public let email: String?
        public let phone: String
        public let password: String?
        public let confirmPassword: String?

        enum CodingKeys: String, CodingKey {
            case surname, name, patronymic, birthday, gender, email, phone, password
            case confirmPassword = "confirm_password"
        }

    }

}
