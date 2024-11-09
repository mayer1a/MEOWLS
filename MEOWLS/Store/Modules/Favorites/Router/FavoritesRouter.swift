//
//  FavoritesRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 23.10.2024.
//

import UIKit

final class FavoritesRouter: CommonRouter, FavoritesRouterProtocol {

    func open(_ route: FavoritesModel.Route) {
        switch route {
        case .product(let product):
            showProduct(product)

        case .propertiesSelectionSheet(let product, let completion):
            showPropertiesSelectionSheet(with: product, completion)

        case .auth:
            showAuth()

        case .catalogue:
            showCatalogue()

        case .networkError(let model):
            showNetworkError(with: model)

        }
    }

}

private extension FavoritesRouter {

    func showProduct(_ product: Product) {

    }

    func showPropertiesSelectionSheet(with product: Product, _ completion: VoidClosure?) {

    }

    func showAuth() {
        Router.showAuthorization {
            Router.showMainController(atTab: .favorites)
        }
    }

    func showCatalogue() {

    }

    func showNetworkError(with model: NetworkErrorAlert) {
        viewController?.showNetworkError(with: model)
    }

}
