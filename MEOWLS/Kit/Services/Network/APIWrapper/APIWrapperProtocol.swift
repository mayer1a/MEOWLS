//
//  APIWrapperProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 16.09.2024.
//

import Alamofire

public protocol APIWrapperProtocol {

    var apiService: APIServiceProtocol { get }

    // MARK: - User

    func signUp(user: User.Update, handler: @escaping ResponseHandler<UserCredential>)
    func signIn(username: String,
                password: String,
                service: APIResourceService?,
                handler: @escaping ResponseHandler<UserCredential>)
    func user(service: APIResourceService?, handler: @escaping ResponseHandler<UserCredential>)
    func updateUser(_ user: User.Update, handler: @escaping ResponseHandler<UserCredential>)
    func refreshToken(handler: @escaping ResponseHandler<UserCredential>)
    func logout(service: APIResourceService?, handler: @escaping ResponseHandler<DummyResponse>)
    func deleteProfile(handler: @escaping ResponseHandler<DummyResponse>)
    func userAddress(service: APIResourceService?, handler: @escaping ResponseHandler<Address>)

    // MARK: - Catalogue

    func products(by ids: [String], with parameters: Parameters?, handler: @escaping ProductsResponse) -> DataRequest?

    // MARK: - Favorites

    func favoritesCount(handler: @escaping ResponseHandler<FavoritesCount>)
    func toggleFavorite(items: [Identifiable], isFavorite: Bool, handler: @escaping ResponseHandler<DummyResponse>)

    // MARK: - Region

    func cities(handler: @escaping ResponseHandler<[City]>)

    // MARK: - Sales

    func sales(type: Sale.SaleType, page: Int, perPage: Int?, handler: @escaping SalesResponse)
    func sale(saleID: String, handler: @escaping ResponseHandler<Sale>)

}
