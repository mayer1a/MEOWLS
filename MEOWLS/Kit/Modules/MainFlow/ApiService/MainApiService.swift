//
//  MainApiService.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import Foundation

final class MainApiService: MainApiServiceProtocol {

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func loadBanners(handler: @escaping ResponseHandler<[MainBanner]>) {
        apiService.get(resource: .banners, service: nil, parameters: ["group": "main"], headers: nil, handler: handler)
    }

    func loadCategory(id: String, handler: @escaping ResponseHandler<[Category]>) {
        apiService.get(resource: .category(id), service: nil, parameters: nil, headers: nil, handler: handler)
    }

    func loadSale(id: String, handler: @escaping ResponseHandler<Sale>) {
        apiService.get(resource: .sale(id), service: nil, parameters: nil, headers: nil, handler: handler)
    }

}
