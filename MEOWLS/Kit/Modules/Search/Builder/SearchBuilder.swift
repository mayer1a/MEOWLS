//
//  SearchBuilder.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.10.2024.
//

import Factory

protocol SearchBuilderProtocol {

    func build(with model: SearchModel.InputModel) -> UIViewController

}

final class SearchBuilder: SearchBuilderProtocol {

    func build(with model: SearchModel.InputModel) -> UIViewController {
        let router = SearchRouter()
        let apiService = SearchApiService(apiService: resolve(\.apiService), apiWrapper: resolve(\.apiWrapper))
        let initialModel = SearchModel.InitialModel(inputModel: model,
                                                    router: router,
                                                    apiService: apiService,
                                                    favoritesService: resolve(\.favoritesService),
                                                    paginator: resolve(\.paginator))
        
        let viewModel = SearchViewModel(with: initialModel)
        let viewController = SearchViewController(viewModel: viewModel)

        router.setCurrent(viewController)

        return viewController
    }

}

// MARK: - Register container

extension Container {

    var searchBuilder: Factory<SearchBuilderProtocol> {
        self { SearchBuilder() }
    }

}
