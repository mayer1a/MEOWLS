//
// AutocompleteFieldApiServiceProtocol.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Foundation

protocol AutocompleteFieldApiServiceProtocol {

    typealias Model = AutocompleteFieldModel

    func getSuggestions(for query: String, type: Model.FieldType, handler: @escaping ResponseHandler<[Suggestion]>)

}
