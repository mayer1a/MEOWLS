//
//  FavoritesModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 23.10.2024.
//

import Combine

public enum FavoritesModel {}

extension FavoritesModel {

    struct InitialModel {
        let router: FavoritesRouterProtocol
        let apiService: FavoritesApiServiceProtocol
        let favoritesService: FavoritesServiceProtocol
        let paginator: PaginatorProtocol
        let user: UserAccess
    }

    enum Route {
        case product(Product)
        case propertiesSelectionSheet(Product, completion: VoidClosure?)
        case auth
        case catalogue
        case networkError(NetworkError)
    }

    struct NetworkError {
        let message: String?
        let repeatHandler: VoidClosure?
    }

}
