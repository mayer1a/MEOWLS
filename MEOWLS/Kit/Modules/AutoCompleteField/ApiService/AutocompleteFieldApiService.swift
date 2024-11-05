//
// AutocompleteFieldApiService.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Foundation

final class AutocompleteFieldApiService: AutocompleteFieldApiServiceProtocol {

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func getSuggestions(for query: String, type: Model.FieldType, handler: @escaping ResponseHandler<[Suggestion]>) {
        let apiPath: APIResourcePath
        switch type {
        case .surname: apiPath = .surnameSuggestions
        case .name: apiPath = .nameSuggestions
        case .patronymic: apiPath = .patronymicSuggestions
        }

        apiService.get(resource: apiPath, service: .store, parameters: ["query": query], headers: nil, handler: handler)
    }

}
