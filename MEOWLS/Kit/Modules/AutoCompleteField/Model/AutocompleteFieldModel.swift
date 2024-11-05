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

    public typealias AutocompleteHandler = (_ value: String, _ gender: UserCredential.Gender?) -> Void

    public struct InputModel {
        public let inputText: String?
        public let completion: AutocompleteHandler
    }

    struct InitialModel {
        let inputModel: InputModel
        let router: AutocompleteFieldRouterProtocol
        let apiService: AutocompleteFieldApiServiceProtocol
    }

    enum Route {}

}
