//
//  CustomError.swift
//  MEOWLS
//
//  Created by Artem Mayer on 01.07.2024.
//

import Foundation

public struct ResponseError: Codable {

    /// HTTP response status (400/401/403 etc.).
    public let status: Int

    /// Custom response headers.
    public let headers: [String: String]

    /// Error code.
    public let code: String

    /// Error reason.
    public let reason: String

    /// Fixes suggested for user.
    public let failures: [ValidationFailure]?

}
