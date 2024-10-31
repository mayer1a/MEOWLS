//
//  AuthorizationBuilder.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import Factory
import SwiftUI
import PhoneNumberKit

public protocol AuthorizationBuilderProtocol {

    func build(with model: AuthorizationModel.InputModel) -> UIViewController

}

public final class AuthorizationBuilder: AuthorizationBuilderProtocol {

    public func build(with model: AuthorizationModel.InputModel) -> UIViewController {
        let router = AuthorizationRouter()
        let apiService = AuthorizationApiService(apiService: resolve(\.apiService))

        let initialModel = AuthorizationModel.InitialModel(inputModel: model,
                                                           user: resolve(\.user),
                                                           router: router,
                                                           apiService: apiService,
                                                           phoneKit: PhoneNumberKit())

        let viewModel = AuthorizationViewModel(with: initialModel)

        let view = AuthorizationView(viewModel: viewModel)
        let viewController = DomainHostingController(rootView: view)
        viewController.setupPresentationMode(with: model.mode)

        router.setCurrent(viewController)

        return viewController
    }

}

// MARK: - Register container

public extension Container {

    var authBuilder: Factory<AuthorizationBuilderProtocol> {
        self { AuthorizationBuilder() }
    }

}
