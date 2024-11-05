//
// ProfileDataViewModel+TextFieldStateFactory.swift
// MEOWLS
//
// Created by Artem Mayer on 04.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Foundation
import PhoneNumberKit

extension ProfileDataViewModel {

    struct TextFieldStateFactory {

        static func makeSurname() -> DomainLabeledTextField.ViewModel {
            .init(dataState: .init(label: "Profile.Edit.surname"), isFocusable: false)
        }

        static func makeName() -> DomainLabeledTextField.ViewModel {
            .init(dataState: .init(label: "Profile.Edit.name", errorText: "Profile.Edit.emptyName"), isFocusable: false)
        }

        static func makePatronymic() -> DomainLabeledTextField.ViewModel {
            .init(dataState: .init(label: "Profile.Edit.patronymic"), isFocusable: false)
        }

        static func makeBirthDate(canEdit: Bool) -> DomainLabeledTextField.ViewModel {
            let viewState: DomainLabeledTextField.ViewModel.ViewState = canEdit ? .default : .disabled
            return .init(dataState: .init(label: "Profile.Edit.birthday"), viewState: viewState, isFocusable: false)
        }

        static func makeEmail() -> DomainLabeledTextField.ViewModel {
            .init(dataState: .init(label: "Profile.Edit.email", errorText: "Profile.Edit.wrongEmail"), isFocusable: true)
        }

        static func makePassword() -> DomainLabeledTextField.ViewModel {
            .init(dataState: .init(label: "Profile.Edit.password"), isFocusable: true, isSecure: true)
        }

        static func makeConfirmPassword() -> DomainLabeledTextField.ViewModel {
            .init(dataState: .init(label: "Profile.Edit.confirmPassword", errorText: "Profile.Edit.wrongConfirmPassword"),
                  isFocusable: true,
                  isSecure: true)
        }

        static func makePhone(exampleNumber: String?) -> DomainLabeledTextField.ViewModel {
            .init(dataState: .init(label: exampleNumber ?? "", errorText: "Common.Authorization.incorrectNumberError"))
        }

    }

}
