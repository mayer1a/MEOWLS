//
//  AuthorizationHelper.swift
//  MEOWLS
//
//  Created by Artem Mayer on 29.10.2024.
//

import Foundation
import Factory

extension AuthorizationViewModel {

    struct AuthorizationHelper {

        typealias Model = AuthorizationModel

        struct CustomerLoginModel {
            let phone: String
            let token: String
            #if Store
                let user: UserAuthorization
            #else
                let user: UserEmployee & UserAccess
            #endif
            let completion: ParameterClosure<String?>
        }

        #if Store

        private typealias User = UserAuthorization

        static func storeLogin(from model: CustomerLoginModel) {
            model.user.login(with: model.phone, accessToken: model.token) { error in
                model.completion(error)
            }
        }

        #elseif POS

        static func posCustomerLogin(from model: CustomerLoginModel) {
            
        }

        static func posStaffLogin(from model: CustomerLoginModel) {
            model.user.changeUserToken(model.token, on: .pos)

            SettingsService.shared[.isUserAuthorized] = true

            Task {
                do {
                    try await model.user.reloadCredentials()
                    model.completion(nil)
                } catch {
                    model.completion(error.localizedDescription)
                }
            }
        }

        #endif

    }

}
