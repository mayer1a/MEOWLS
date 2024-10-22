//
//  SearchApiServiceProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.10.2024.
//

import Alamofire

protocol SearchApiServiceProtocol {

    func popularSearchSuggestions(handler: @escaping ResponseHandler<[SearchSuggestion]>)
    func search(query: String, handler: @escaping ResponseHandler<[SearchSuggestion]>) -> DataRequest?
    func loadProducts(ids: [String], with parameters: Parameters?, handler: @escaping ProductsResponse) -> DataRequest?

}
