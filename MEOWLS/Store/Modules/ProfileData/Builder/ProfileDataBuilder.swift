//
//  ProfileDataBuilder.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Factory
import SwiftUI
import PhoneNumberKit

protocol ProfileDataBuilderProtocol {

    func build(with model: ProfileDataModel.InputModel) -> UIViewController

}

final class ProfileDataBuilder: ProfileDataBuilderProtocol {

    func build(with model: ProfileDataModel.InputModel) -> UIViewController {
        let router = ProfileDataRouter()
        let apiService = ProfileDataApiService(apiService: resolve(\.apiService), apiWrapper: resolve(\.apiWrapper))

        let initialModel = ProfileDataModel.InitialModel(inputModel: model,
                                                         phoneKit: PhoneNumberKit(),
                                                         router: router,
                                                         apiService: apiService)

        let childViewModel = ProfileDataChildViewModel(user: resolve(\.user), apiService: apiService, mode: model.mode)
        let viewModel = ProfileDataViewModel(with: initialModel, childViewModel: childViewModel)

        let view = ProfileDataView(viewModel: viewModel)
        let viewController = DomainHostingController(rootView: view, navigationBarHidden: true)

        router.setCurrent(viewController)

        return viewController
    }

    fileprivate init() {}

}

// MARK: - Register container

extension Container {

    var profileDataBuilder: Factory<ProfileDataBuilderProtocol> {
        self { ProfileDataBuilder() }
    }

}
