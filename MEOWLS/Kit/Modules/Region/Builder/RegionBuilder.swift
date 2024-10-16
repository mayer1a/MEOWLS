//
//  RegionBuilder.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.09.2024.
//

import Factory

protocol RegionBuilderProtocol {

    func build(with model: RegionModel.InputModel) -> UIViewController

}

final class RegionBuilder: RegionBuilderProtocol {

    func build(with model: RegionModel.InputModel) -> UIViewController {
        let router: RegionRouterProtocol = RegionRouter()
        let apiService: RegionApiServiceProtocol = RegionApiService(apiService: resolve(\.apiService))
        let initialModel = RegionModel.InitialModel(inputModel: model,
                                                    router: router,
                                                    apiService: apiService,
                                                    regionAgent: resolve(\.regionAgent),
                                                    locationManager: resolve(\.locationManager))
        let viewModel = RegionViewModel(with: initialModel)
        let viewController = UINavigationController(rootViewController: RegionViewController(viewModel: viewModel))
        viewController.modalPresentationStyle = .fullScreen
        viewController.navigationController?.modalPresentationStyle = .fullScreen
        viewController.isModalInPresentation = true

        router.setCurrent(viewController)

        return viewController
    }

}

// MARK: - Register container

extension Container {

    var regionBuilder: Factory<RegionBuilderProtocol> {
        self { RegionBuilder() }
    }

}



