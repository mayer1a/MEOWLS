//
//  AuthorizationApiServiceProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import Foundation

protocol AuthorizationApiServiceProtocol {

    func signIn(phone: String,
                password: String,
                service: APIResourceService?,
                handler: @escaping ResponseHandler<UserCredential>)

}
