//
// AutocompleteFieldBuilder.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Factory
import SwiftUI

public protocol AutocompleteFieldBuilderProtocol {

    func build(with model: AutocompleteFieldModel.InputModel) -> UIViewController

}

final class AutocompleteFieldBuilder: AutocompleteFieldBuilderProtocol {

    func build(with model: AutocompleteFieldModel.InputModel) -> UIViewController {
        let router = AutocompleteFieldRouter()
        let apiService = AutocompleteFieldApiService(apiService: resolve(\.apiService))

        let initialModel = AutocompleteFieldModel.InitialModel(inputModel: model,
                                                               router: router,
                                                               apiService: apiService)
        let viewModel = AutocompleteFieldViewModel(with: initialModel)

        let view = AutocompleteFieldView(viewModel: viewModel)
        let viewController = DomainHostingController(rootView: view, navigationBarHidden: true)

        router.setCurrent(viewController)

        return viewController
    }

    fileprivate init() {}

}

// MARK: - Register container

public extension Container {

    var autoCompleteFieldBuilder: Factory<AutocompleteFieldBuilderProtocol> {
        self { AutocompleteFieldBuilder() }
    }

}
