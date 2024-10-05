//
//  APIWrapperProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 16.09.2024.
//

import Alamofire

public protocol APIWrapperProtocol {

    var apiService: APIServiceProtocol { get }

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

    func favoritesCount(handler: @escaping ResponseHandler<FavoritesCount>)
    func toggleFavorite(items: [Identifiable], isFavorite: Bool, handler: @escaping ResponseHandler<DummyResponse>)

    func cities(handler: @escaping ResponseHandler<[City]>)

    func sales(type: Sale.SaleType,
               page: Int,
               perPage: Int?,
               handler: @escaping ResponseHandler<PaginationResponse<Sale>>)
    func sale(saleID: String, handler: @escaping ResponseHandler<Sale>)

}
