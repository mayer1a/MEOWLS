//
// AutocompleteFieldViewModel.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import UIKit
import Combine

final class AutocompleteFieldViewModel: AutocompleteFieldViewModelProtocol {

    @Published private(set) var isLoading: Bool = false

    private let router: AutocompleteFieldRouterProtocol
    private var selectedCompletion: Model.AutocompleteHandler?
    private let apiService: AutocompleteFieldApiServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(with model: Model.InitialModel) {
        self.selectedCompletion = model.inputModel.completion
        self.router = model.router
        self.apiService = model.apiService
    }

}

extension AutocompleteFieldViewModel {

}

private extension AutocompleteFieldViewModel {

}

private extension AutocompleteFieldViewModel {

}
