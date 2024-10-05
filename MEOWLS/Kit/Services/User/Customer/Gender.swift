//
//  Gender.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public extension UserCredential {

    enum Gender: String, CustomStringConvertible, Codable {

        case man
        case woman

        public init?(with rawValue: String?) {
            guard let rawValue else { return nil }

            switch rawValue {
            case Gender.man.rawValue: self = .man
            case Gender.woman.rawValue: self = .woman
            default: return nil
            }
        }

        public var description: String {
            switch self {
            case .woman:
                return Gender.woman.rawValue

            case .man:
                return Gender.man.rawValue

            }
        }

        #warning("LOCALIZE!")
        public var localizableDescription: String {
            switch self {
            case .man:
                return "Мужской"

            case .woman:
                return "Женский"

            }
        }

    }

}
