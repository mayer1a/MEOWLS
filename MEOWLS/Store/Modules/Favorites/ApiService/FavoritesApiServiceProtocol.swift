//
//  FavoritesApiServiceProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 23.10.2024.
//

import Alamofire

protocol FavoritesApiServiceProtocol {

    func loadFavorites(with parameters: Parameters?, handler: @escaping ProductsResponse)
    func loadProducts(ids: [String], with parameters: Parameters?, handler: @escaping ProductsResponse)

}
