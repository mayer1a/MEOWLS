//
//  UserAuthentication.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.08.2024.
//

import Foundation

public extension User {

    struct Authentication: Codable {
        
        public let token: String?
        public let expiresAt: Date?

        enum CodingKeys: String, CodingKey {
            case token
            case expiresAt = "expires_at"
        }

    }

}
