//
//  KeychainError.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation
import Security

public enum KeychainError: Error {

    case Unimplemented
    case Param
    case Allocate
    case NotAvailable
    case AuthFailed
    case DuplicateItem
    case ItemNotFound
    case InteractionNotAllowed
    case Decode
    case Unknown

    public static func errorFromOSStatus(_ rawStatus: OSStatus) -> KeychainError? {
        rawStatus == errSecSuccess ? nil : mapping[rawStatus] ?? .Unknown
    }

    public static let mapping: [Int32: KeychainError] = [
        errSecUnimplemented: .Unimplemented,
        errSecParam: .Param,
        errSecAllocate: .Allocate,
        errSecNotAvailable: .NotAvailable,
        errSecAuthFailed: .AuthFailed,
        errSecDuplicateItem: .DuplicateItem,
        errSecItemNotFound: .ItemNotFound,
        errSecInteractionNotAllowed: .InteractionNotAllowed,
        errSecDecode: .Decode
    ]

}
