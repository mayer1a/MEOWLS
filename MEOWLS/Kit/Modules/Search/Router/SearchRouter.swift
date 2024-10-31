//
//  SearchRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.10.2024.
//

import UIKit

final class SearchRouter: CommonRouter, SearchRouterProtocol {

    func open(_ route: SearchModel.Route) {
        switch route {
        case .category(let category):
            showCategory(category)

        case .product(let product):
            showProduct(product)

        case .products(let productsIDs, let title):
            showProducts(productsIDs, with: title)

        case .networkError(let model):
            showNetworkError(with: model)

        }
    }

}

private extension SearchRouter {

    func showCategory(_ category: Category) {

    }

    func showProduct(_ product: Product) {

    }

    func showProducts(_ productsIDs: [String], with title: String) {

    }

    func showNetworkError(with model: NetworkErrorAlert) {
        viewController?.showNetworkError(with: model)
    }

}
