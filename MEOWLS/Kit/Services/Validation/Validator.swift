//
// Validator.swift
// MEOWLS
//
// Created by Artem Mayer on 03.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Foundation

public struct Validator {

    public static func validatePassword(_ password: String, confirmPassword: String? = nil) throws -> String {
        if confirmPassword != nil, password != confirmPassword {
            throw PasswordError.passwordsDidNotMatch
        }

        guard password.count >= 8 else {
            throw PasswordError.tooShort
        }

        guard password.range(of: ".*[A-Z].*", options: .regularExpression) != nil else {
            throw PasswordError.noUppercase
        }

        guard password.range(of: ".*[a-z].*", options: .regularExpression) != nil else {
            throw PasswordError.noLowercase
        }

        let digitRegex = ".*[0-9].*"
        guard password.range(of: digitRegex, options: .regularExpression) != nil else {
            throw PasswordError.noDigit
        }

        return password
    }

    public static func validateEmail(_ email: String) throws -> String {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        guard email.range(of: emailRegex, options: .regularExpression) != nil else {
            throw EmailError.invalidFormat
        }

        return email
    }

}

public extension Validator {

    enum PasswordError: LocalizedError {

        case tooShort
        case noUppercase
        case noLowercase
        case noDigit
        case passwordsDidNotMatch

        public var errorDescription: String? {
            switch self {
            case .tooShort:
                return Strings.Common.Registration.passwordLength

            case .noUppercase:
                return Strings.Common.Registration.upperCase

            case .noLowercase:
                return Strings.Common.Registration.lowercase

            case .noDigit:
                return Strings.Common.Registration.digit

            case .passwordsDidNotMatch:
                return Strings.Common.Registration.passwordDidNotMatch

            }
        }

    }

    enum EmailError: LocalizedError {

        case invalidFormat

        public var errorDescription: String? {
            switch self {
            case .invalidFormat:
                return Strings.Common.Registration.email

            }
        }

    }

}
