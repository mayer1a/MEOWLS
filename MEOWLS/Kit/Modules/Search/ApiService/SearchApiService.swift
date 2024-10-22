//
//  SearchApiService.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.10.2024.
//

import Alamofire

final class SearchApiService: SearchApiServiceProtocol {

    private let apiService: APIServiceProtocol
    private let apiWrapper: APIWrapperProtocol

    init(apiService: APIServiceProtocol, apiWrapper: APIWrapperProtocol) {
        self.apiService = apiService
        self.apiWrapper = apiWrapper
    }

}

extension SearchApiService {

    func popularSearchSuggestions(handler: @escaping ResponseHandler<[SearchSuggestion]>) {
        apiService.get(resource: .popularSearches, service: nil, parameters: nil, headers: nil, handler: handler)
    }

    func search(query: String, handler: @escaping ResponseHandler<[SearchSuggestion]>) -> DataRequest? {
        let parameters = ["query": query]
        return apiService.get(resource: .search, service: nil, parameters: parameters, headers: nil, handler: handler)
    }

    func loadProducts(ids: [String],
                      with parameters: Parameters?,
                      handler: @escaping ProductsResponse) -> DataRequest? {
        
        apiWrapper.products(by: ids, with: parameters, handler: handler)
    }

}
