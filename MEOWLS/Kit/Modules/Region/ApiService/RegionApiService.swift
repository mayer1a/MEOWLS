//
//  RegionApiService.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.09.2024.
//

import Foundation

final class RegionApiService: RegionApiServiceProtocol {

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

}

extension RegionApiService {

    func getCitiesGeoIP(handler: @escaping ResponseHandler<[City]>) {
        apiService.get(resource: .cities, service: nil, parameters: nil, headers: nil, handler: handler)
    }

}
