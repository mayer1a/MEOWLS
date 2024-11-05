//
// AutocompleteFieldModel.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Foundation

public enum AutocompleteFieldModel {}

extension AutocompleteFieldModel {

    public enum FieldType {

        case surname, name, patronymic

        init(rawValue: String) {
            switch rawValue {
            case "surname": self = .surname
            case "patronymic": self = .patronymic
            default: self = .name
            }
        }

    }

    public typealias AutocompleteHandler = (_ value: String, _ gender: UserCredential.Gender?) -> Void

    public struct InputModel {
        public let inputText: String?
        public let fieldType: FieldType
        public let completion: AutocompleteHandler
    }

    struct InitialModel {
        let inputModel: InputModel
        let router: AutocompleteFieldRouterProtocol
        let apiService: AutocompleteFieldApiServiceProtocol
    }

    enum Route {}

    struct Hint: Swift.Identifiable, Equatable {
        let id: String = UUID().uuidString
        let text: AttributedString
        let gender: UserCredential.Gender?
    }

}
