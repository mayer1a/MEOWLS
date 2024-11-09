//
//  AuthorizationApiService.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import Foundation
import Alamofire

final class AuthorizationApiService: AuthorizationApiServiceProtocol {

    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func signIn(phone: String,
                password: String,
                service: APIResourceService?,
                handler: @escaping ResponseHandler<UserCredential>) {

        let authHeader = HTTPHeaders(arrayLiteral: .authorization(username: phone, password: password))
        apiService.post(resource: .signIn, service: service, parameters: nil, headers: authHeader, handler: handler)
    }

}
