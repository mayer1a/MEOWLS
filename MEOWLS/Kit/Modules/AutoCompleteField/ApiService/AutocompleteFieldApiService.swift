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

}
