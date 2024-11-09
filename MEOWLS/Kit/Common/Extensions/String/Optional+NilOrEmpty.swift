//
//  Optional+NilOrEmpty.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public extension Optional where Wrapped == String {

    var isNilOrEmpty: Bool {
        switch self {
        case let string?:
            return string.isEmpty

        case nil:
            return true

        }
    }

    var isNilEmptyOrWhitespaceOnly: Bool {
        switch self {
        case let string?:
            return string.isEmpty ? true : string.isWhitespacesOnly

        case nil:
            return true

        }
    }

}

public extension Optional where Wrapped: Collection {

    var isNilOrEmpty: Bool {
        switch self {
        case let collection?:
            return collection.isEmpty

        case nil:
            return true

        }
    }

}
