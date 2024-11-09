//
// ProfileDataViewModel+UserBuilder.swift
// MEOWLS
//
// Created by Artem Mayer on 03.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Foundation

extension ProfileDataViewModel {

    final class UserBuilder {

        init(isFullValidation: Bool) {
            self.isFullValidation = isFullValidation
        }

        private var isFullValidation: Bool
        private var surname: String?
        private var name: String?
        private var patronymic: String?
        private var birthDate: Date?
        private var gender: UserCredential.Gender?
        private var phone: String?
        private var email: String?
        private var password: String?
        private var confirmPassword: String?

        @discardableResult
        func setSurname(_ surname: String?) -> Self {
            self.surname = surname
            return self
        }

        @discardableResult
        func setName(_ name: String?) -> Self {
            self.name = name
            return self
        }

        @discardableResult
        func setPatronymic(_ patronymic: String?) -> Self {
            self.patronymic = patronymic
            return self
        }

        @discardableResult
        func setBirthdate(_ birthDate: Date?) -> Self {
            self.birthDate = birthDate
            return self
        }

        @discardableResult
        func setGender(_ gender: UserCredential.Gender?) -> Self {
            self.gender = gender
            return self
        }

        @discardableResult
        func setPhone(_ phone: String?) -> Self {
            self.phone = phone
            return self
        }

        @discardableResult
        func setEmail(_ email: String?) -> Self {
            self.email = email
            return self
        }

        @discardableResult
        func setPassword(_ password: String?) -> Self {
            self.password = password
            return self
        }

        @discardableResult
        func setConfirmPassword(_ confirmPassword: String?) -> Self {
            self.confirmPassword = confirmPassword
            return self
        }

        @discardableResult
        func validate() throws -> (name: String, phone: String, email: String?, password: String?) {
            guard let name, !name.isEmpty else {
                throw BuilderError.emptyName
            }
            guard let phone, !phone.isEmpty else {
                throw BuilderError.emptyPhone
            }

            var validatedEmail: String?
            var validatedPassword: String?

            if let email, !email.isEmpty {
                validatedEmail = try Validator.validateEmail(email)
            }

            if isFullValidation || !password.isNilOrEmpty {
                validatedPassword = try Validator.validatePassword(password ?? "", confirmPassword: confirmPassword ?? "")
            }

            return (name: name, phone: phone, email: validatedEmail, password: validatedPassword)
        }

        func build() throws -> User.Update {
            let (name, phone, validatedEmail, validatedPassword) = try validate()

            let surname = surname.isNilOrEmpty ? nil : surname
            let patronymic = patronymic.isNilOrEmpty ? nil : patronymic

            return User.Update(surname: surname,
                               name: name,
                               patronymic: patronymic,
                               birthday: birthDate.map({ $0.toClearISO8601 }),
                               gender: gender,
                               email: validatedEmail,
                               phone: phone,
                               password: validatedPassword,
                               confirmPassword: validatedPassword)
        }

    }

}

extension ProfileDataViewModel.UserBuilder {

    enum BuilderError: LocalizedError {

        case emptyName
        case emptyPhone

        var errorDescription: String? {
            switch self {
            case .emptyName:
                return Strings.Profile.UserProfile.emptyname

            case .emptyPhone:
                return Strings.NetworkError.phoneRequired

            }
        }

    }

}
