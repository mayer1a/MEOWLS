//
//  FavoritesApiService.swift
//  MEOWLS
//
//  Created Artem Mayer on 23.10.2024.
//

import Alamofire

final class FavoritesApiService: FavoritesApiServiceProtocol {

    private let apiService: APIServiceProtocol
    private let apiWrapper: APIWrapperProtocol

    init(apiService: APIServiceProtocol, apiWrapper: APIWrapperProtocol) {
        self.apiService = apiService
        self.apiWrapper = apiWrapper
    }

}

extension FavoritesApiService {

    func loadFavorites(with parameters: Parameters?, handler: @escaping ProductsResponse) {
        apiService.get(resource: .favorites, service: nil, parameters: parameters, headers: nil, handler: handler)
    }

    func loadProducts(ids: [String], with parameters: Parameters?, handler: @escaping ProductsResponse) {
        apiWrapper.products(by: ids, with: parameters, handler: handler)
    }

}
