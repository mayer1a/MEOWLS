//
// ProfileDataViewModel+ErrorState.swift
// MEOWLS
//
// Created by Artem Mayer on 05.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import PhoneNumberKit

extension ProfileDataViewModel {

    @discardableResult
    func validate(userBuilder: UserBuilder, phoneKit: PhoneNumberKit) -> Bool {
        do {
            try userBuilder
                .setSurname(surname)
                .setName(name)
                .setPatronymic(patronymic)
                .setBirthdate(birthDate)
                .setGender(gender)
                .setPhone(phoneKit.verifyPhoneNumber(phone, for: selectedRegion))
                .setEmail(email)
                .setPassword(password)
                .setConfirmPassword(confirmPassword)
                .validate()

            return true

        } catch {
            let rows: [Model.Row] = [.name, .phone(), .email, .password, .confirmPassword]
            rows.forEach {
                updateErrorState(for: $0, hasError: false)
            }
            if let error = error as? UserBuilder.BuilderError {
                updateErrorState(for: error == .emptyName ? .name : .phone(), hasError: true)
            } else if let error = error as? Validator.PasswordError {
                if error == .passwordsDidNotMatch {
                    updateErrorState(for: .confirmPassword, hasError: true)
                } else {
                    updateErrorState(for: .password, hasError: true, error: error.localizedDescription)
                }
            } else if error is Validator.EmailError {
                updateErrorState(for: .email, hasError: true)
            } else if error is PhoneNumberError {
                updateErrorState(for: .phone(), hasError: true)
            }

            return false
        }
    }

    func updateErrorState(for row: Model.Row, hasError: Bool, error: String? = nil) {
        switch row {
        case .name:
            nameState.viewState = hasError ? .errorDefault : .default

        case .phone:
            phoneState.viewState = hasError ? .errorDefault : .default

        case .email:
            emailState.viewState = hasError ? .errorDefault : .default

        case .password:
            passwordState.dataState.errorText = error ?? "Profile.Edit.wrongPassword"
            passwordState.viewState = hasError ? .errorDefault : .default

        case .confirmPassword:
            confirmPasswordState.viewState = hasError ? .errorDefault : .default

        default:
            break

        }
    }

}
