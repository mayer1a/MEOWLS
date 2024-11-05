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

    @Published var query: String
    @Published var textFieldState: DomainLabeledTextField.ViewModel
    @Published private(set) var title: String = ""
    @Published private(set) var hints: [Model.Hint] = []
    @Published private(set) var isLoading: Bool = false

    private let fieldType: Model.FieldType
    private let router: AutocompleteFieldRouterProtocol
    private var selectedCompletion: Model.AutocompleteHandler?
    private let apiService: AutocompleteFieldApiServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(with model: Model.InitialModel) {
        self.query = model.inputModel.inputText ?? ""
        self.fieldType = model.inputModel.fieldType
        self.selectedCompletion = model.inputModel.completion
        self.router = model.router
        self.apiService = model.apiService

        let textFieldLabel: String
        switch model.inputModel.fieldType {
        case .surname: textFieldLabel = "Profile.Edit.surname"
        case .name: textFieldLabel = "Profile.Edit.name"
        case .patronymic: textFieldLabel = "Profile.Edit.patronymic"
        }

        textFieldState = .init(dataState: .init(label: textFieldLabel))
    }

}

extension AutocompleteFieldViewModel {

}

private extension AutocompleteFieldViewModel {

}

private extension AutocompleteFieldViewModel {

}
