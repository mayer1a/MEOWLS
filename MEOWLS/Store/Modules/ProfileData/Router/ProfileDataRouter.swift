//
//  ProfileDataRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import UIKit
import Factory

final class ProfileDataRouter: CommonRouter, ProfileDataRouterProtocol {

    func open(_ route: ProfileDataModel.Route) {
        switch route {
        case .warning(let title, let message):
            viewController?.showRedAlert(title: title, message: message, actions: .ok)

        case .networkError(let model):
            viewController?.showNetworkError(with: model)

        }
    }

}

private extension ProfileDataRouter {
}
