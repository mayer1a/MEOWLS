//
//  APIWrapper.swift
//  MEOWLS
//
//  Created by Artem Mayer on 11.09.2024.
//

import Alamofire
import Factory

public class APIWrapper: APIWrapperProtocol {

    fileprivate init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    public let apiService: APIServiceProtocol

    // MARK: - User

    public func signUp(user: User.Update, handler: @escaping ResponseHandler<UserCredential>) {
        let data = try? JSONEncoder().encode(user)
        apiService.post(resource: .signUp, service: .store, data: data, headers: nil, handler: handler)
    }

    public func signIn(username: String,
                       password: String,
                       service: APIResourceService? = nil,
                       handler: @escaping ResponseHandler<UserCredential>) {

        let parameters = HTTPHeaders(arrayLiteral: .authorization(username: username, password: password)).dictionary
        apiService.post(resource: .signIn, service: service, parameters: parameters, headers: nil, handler: handler)
    }

    public func user(service: APIResourceService? = nil, handler: @escaping ResponseHandler<UserCredential>) {
        apiService.get(resource: .user, service: service, parameters: nil, headers: nil, handler: handler)
    }

    public func updateUser(_ user: User.Update, handler: @escaping ResponseHandler<UserCredential>) {
        let data = try? JSONEncoder().encode(user)
        apiService.post(resource: .updateUser, service: .store, data: data, headers: nil, handler: handler)
    }

    public func refreshToken(handler: @escaping ResponseHandler<UserCredential>) {
        apiService.post(resource: .refreshToken, service: nil, parameters: nil, headers: nil, handler: handler)
    }

    public func logout(service: APIResourceService? = nil, handler: @escaping ResponseHandler<DummyResponse>) {
        apiService.post(resource: .logout, service: service, parameters: nil, headers: nil, handler: handler)
    }

    public func deleteProfile(handler: @escaping ResponseHandler<DummyResponse>) {
        apiService.post(resource: .deleteProfile, service: nil, parameters: nil, headers: nil, handler: handler)
    }

    public func userAddress(service: APIResourceService? = nil, handler: @escaping ResponseHandler<Address>) {
        apiService.post(resource: .userAddress, service: service, parameters: nil, headers: nil, handler: handler)
    }

    // MARK: - Catalogue

    @discardableResult
    public func products(by ids: [String],
                         with parameters: Parameters?,
                         handler: @escaping ProductsResponse) -> DataRequest? {
        
        var parameters = parameters ?? [:]
        parameters["products_ids"] = ids.joined(separator: ",")

        return apiService.get(resource: .products, service: nil, parameters: parameters, headers: nil, handler: handler)
    }

    // MARK: - Favorites

    public func favoritesCount(handler: @escaping ResponseHandler<FavoritesCount>) {
        apiService.get(resource: .favoritesCount, service: nil, parameters: nil, headers: nil, handler: handler)
    }

    public func toggleFavorite(items: [Identifiable],
                               isFavorite: Bool,
                               handler: @escaping ResponseHandler<DummyResponse>) {
        
        let ids = items.map({ $0.identifier })
        let data = try? JSONEncoder().encode(ids)
        let path: APIResourcePath = isFavorite ? .markFavorite : .unmarkFavorite

        apiService.post(resource: path, service: nil, data: data, headers: nil, handler: handler)
    }

    // MARK: - Cities

    public func cities(handler: @escaping ResponseHandler<[City]>) {
        apiService.get(resource: .cities, service: nil, parameters: nil, headers: nil, handler: handler)
    }

    // MARK: - Sales

    public func sales(type: Sale.SaleType, page: Int, perPage: Int? = nil, handler: @escaping SalesResponse) {

        var parameters: Parameters = ["sale_type": type, "page": page]

        if let perPage {
            parameters["per_page"] = perPage
        }
        apiService.get(resource: .sales, service: nil, parameters: parameters, headers: nil, handler: handler)
    }

    public func sale(saleID: String, handler: @escaping ResponseHandler<Sale>) {
        apiService.get(resource: .sale(saleID), service: nil, parameters: nil, headers: nil, handler: handler)
    }

}

// MARK: - Register container

public extension Container {

    var apiWrapper: Factory<APIWrapperProtocol> {
        self {
            APIWrapper(apiService: resolve(\.apiService))
        }
        .singleton
    }

}
