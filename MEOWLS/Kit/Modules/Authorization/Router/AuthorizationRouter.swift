//
//  AuthorizationRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import UIKit

final class AuthorizationRouter: CommonRouter, AuthorizationRouterProtocol {

    func open(_ route: AuthorizationModel.Route) {
        switch route {
        case .signUp(let phone):
            openSignUp(with: phone)

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

    func openSignUp(with phone: String?) {
        
    }

    func openResetPassword(with phone: String?) {

    }

    func openAgreement(url: URL?, with mode: AuthorizationModel.Mode) {
        let webViewController = DomainWebViewController(for: url)
        webViewController.setupPresentationMode(with: mode)

        viewController?.present(UINavigationController(rootViewController: webViewController))
    }

}
