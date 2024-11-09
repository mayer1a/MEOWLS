//
//  FavoritesBuilder.swift
//  MEOWLS
//
//  Created Artem Mayer on 23.10.2024.
//

import Factory
import SwiftUI

public protocol FavoritesBuilderProtocol {

    func build() -> UIViewController

}

final class FavoritesBuilder: FavoritesBuilderProtocol {

    func build() -> UIViewController {
        let router = FavoritesRouter()
        let apiService = FavoritesApiService(apiService: resolve(\.apiService), apiWrapper: resolve(\.apiWrapper))
        let initialModel = FavoritesModel.InitialModel(router: router,
                                                       apiService: apiService,
                                                       favoritesService: resolve(\.favoritesService),
                                                       paginator: resolve(\.paginator),
                                                       user: resolve(\.user))
        
        let viewModel = FavoritesViewModel(with: initialModel)
        let view = FavoritesView(viewModel: viewModel)
        let viewController = DomainHostingController(rootView: view)

        router.setCurrent(viewController)

        return viewController
    }

}

// MARK: - Register container

public extension Container {

    var favoritesBuilder: Factory<FavoritesBuilderProtocol> {
        self { FavoritesBuilder() }
    }

}
