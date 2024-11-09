//
//  MainRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import UIKit
import Factory

final class MainRouter: CommonRouter, MainRouterProtocol {

    func open(_ route: MainModel.Route) {
        switch route {
        case .search:
            showSearch()

        case .product(let product):
            showProduct(product)

        case .productsSet(let query, let title):
            showProductsSet(for: query, with: title)

        case .category(let category):
            showCategory(category)

        case .webView(let url):
            showWebView(with: url)

        case .sale(let sale):
            showSale(sale)

        case .pushSubscriptionDialog:
            showPushSubscriptionDialog()

        }
    }

}

private extension MainRouter {

    func showSearch() {
        let searchViewController = resolve(\.searchBuilder).build(with: .init())
        let navigationViewController = UINavigationController(rootViewController: searchViewController)
        navigationViewController.modalTransitionStyle = .crossDissolve
        navigationViewController.modalPresentationStyle = .overCurrentContext

        if let tabViewController = viewController?.tabBarController {
            tabViewController.present(navigationViewController)
        } else {
            present(navigationViewController)
        }
    }

    func showProduct(_ product: Product) {
    }

    func showProductsSet(for query: String, with title: String){
    }

    func showCategory(_ category: Category) {
    }

    func showSale(_ sale: Sale) {
    }

    func showWebView(with url: URL) {
        let controller = DomainWebViewController(for: url)
        let navigation = UINavigationController(rootViewController: controller)
        controller.setupPresentationMode(with: .pageSheet())
        
        present(navigation)
    }

    func showPushSubscriptionDialog() {
    }

}
