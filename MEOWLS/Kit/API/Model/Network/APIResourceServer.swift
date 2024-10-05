//
//  APIResourceServer.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public enum APIResourceServer: Equatable {

    case development
    case production
    case custom(address: String)

}

public extension APIResourceServer {

    static var defaultCases: [APIResourceServer] {
        [.development, .production]
    }

}

extension APIResourceServer: Codable {

    enum CodingKeys: CodingKey, CaseIterable {
        case development, production, customAddress
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        if let _ = try? values.decode(Bool.self, forKey: .development) {
            self = .development
        } else if let _ = try? values.decode(Bool.self, forKey: .production) {
            self = .production
        } else if let address = try? values.decode(String.self, forKey: .customAddress) {
            self = .custom(address: address)
        } else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Cannot decode ApiResourceServer")
            throw DecodingError.dataCorrupted(context)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .development:
            try container.encode(true, forKey: .development)

        case .production:
            try container.encode(true, forKey: .production)

        case .custom(let address):
            try container.encode(address, forKey: .customAddress)

        }
    }

}
