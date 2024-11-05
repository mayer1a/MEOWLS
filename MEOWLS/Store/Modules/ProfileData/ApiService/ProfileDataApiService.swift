//
//  ProfileDataApiService.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Foundation

final class ProfileDataApiService: ProfileDataApiServiceProtocol {

    private let apiService: APIServiceProtocol
    private let apiWrapper: APIWrapperProtocol

    init(apiService: APIServiceProtocol, apiWrapper: APIWrapperProtocol) {
        self.apiService = apiService
        self.apiWrapper = apiWrapper
    }

    func updateUserData(with newUser: User.Update, handler: @escaping ResponseHandler<UserCredential>) {
    }

    func signUp(user: User.Update, handler: @escaping ResponseHandler<UserCredential>) {
    }

    func reloadUser(handler: @escaping ResponseHandler<UserCredential>) {
    }

}
