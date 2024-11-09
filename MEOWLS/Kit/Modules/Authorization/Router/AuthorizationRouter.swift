//
//  AuthorizationRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import UIKit
import Factory

final class AuthorizationRouter: CommonRouter, AuthorizationRouterProtocol {

    func open(_ route: AuthorizationModel.Route) {
        switch route {
        case .signUp(let model):
            #if Store
                openSignUp(with: model)
            #endif

        case .resetPassword(let phone):
            openResetPassword(with: phone)

        case .agreement(let url, let mode):
            openAgreement(url: url, with: mode)

        case .networkError(let model):
            viewController?.showNetworkError(with: model)

        }
    }

    func popViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }

}

private extension AuthorizationRouter {

    #if Store

    func openSignUp(with model: ProfileDataModel.InputModel) {
        let signUpViewController = resolve(\.profileDataBuilder).build(with: model)
        viewController?.push(signUpViewController)
    }

    #endif

    func openResetPassword(with phone: String?) {
        
    }

    func openAgreement(url: URL?, with mode: AuthorizationModel.Mode) {
        let webViewController = DomainWebViewController(for: url)
        webViewController.setupPresentationMode(with: mode)

        viewController?.present(UINavigationController(rootViewController: webViewController))
    }

}
