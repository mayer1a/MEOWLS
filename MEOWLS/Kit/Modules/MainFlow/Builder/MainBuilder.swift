//
//  MainBuilder.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import Factory

protocol MainBuilderProtocol {

    func build(with model: MainModel.InputModel) -> UIViewController

}

final class MainBuilder: MainBuilderProtocol {

    func build(with model: MainModel.InputModel) -> UIViewController {
        let router: MainRouterProtocol = MainRouter()
        let apiService: MainApiServiceProtocol = MainApiService(apiService: resolve(\.apiService))
        let initialModel = MainModel.InitialModel(inputModel: model,
                                                  router: router,
                                                  apiService: apiService,
                                                  favoritesService: resolve(\.favoritesService))
        let viewModel = MainViewModel(with: initialModel)
        let viewController = MainViewController(viewModel: viewModel)

        router.setCurrent(viewController)

        return viewController
    }

}

// MARK: - Register container

extension Container {

    var mainBuilder: Factory<MainBuilderProtocol> {
        self { MainBuilder() }
    }

}
