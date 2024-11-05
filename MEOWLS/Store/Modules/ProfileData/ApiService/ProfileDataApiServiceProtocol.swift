//
//  ProfileDataApiServiceProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Foundation

protocol ProfileDataApiServiceProtocol {

    func signUp(user: User.Update, handler: @escaping ResponseHandler<UserCredential>)
    func updateUserData(with newUser: User.Update, handler: @escaping ResponseHandler<UserCredential>)
    func reloadUser(handler: @escaping ResponseHandler<UserCredential>)

}
