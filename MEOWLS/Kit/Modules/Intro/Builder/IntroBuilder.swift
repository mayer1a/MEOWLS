//
//  IntroBuilder.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.09.2024.
//

import Factory

public protocol IntroBuilderProtocol {

    func build(with model: IntroModel.InputModel) -> UIViewController

}

public final class IntroBuilder: IntroBuilderProtocol {

    public func build(with model: IntroModel.InputModel) -> UIViewController {
        let router: IntroRouterProtocol = IntroRouter()
        let initialModel = IntroModel.InitialModel(inputModel: model, router: router)

        let viewModel = IntroViewModel(with: initialModel, childVM: IntroChildViewModel(user: resolve(\.user)))
        let viewController = IntroViewController(viewModel: viewModel)

        router.setCurrent(viewController)

        return viewController
    }

}

// MARK: - Register container

public extension Container {

    var introBuilder: Factory<IntroBuilderProtocol> {
        self { IntroBuilder() }
    }

}
