//
//  ValidationFailure.swift
//  MEOWLS
//
//  Created by Artem Mayer on 01.07.2024.
//

import Foundation

/// Structure for validation error failures.
public struct ValidationFailure: Codable {

    /// Field with validation error.
    public var field: String

    /// Validation message.
    public var failure: String?

}
