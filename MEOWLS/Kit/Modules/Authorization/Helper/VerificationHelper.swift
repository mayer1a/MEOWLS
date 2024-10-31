//
//  VerificationHelper.swift
//  MEOWLS
//
//  Created by Artem Mayer on 30.10.2024.
//

import Foundation

extension AuthorizationViewModel {

    struct VerificationHelper {

        static func verifyPassword(_ password: String) throws -> String {
            let passwordRegex = #"^(?=.*[0-9])(?=.*[A-Z])[A-Za-z0-9]{6,}$"#

            guard password.range(of: passwordRegex, options: .regularExpression) != nil else {
                #if Store
                    let domain = "ru.artemayer.meowls.store.authorization"
                #else
                    let domain = "ru.artemayer.meowls.pos.authorization"
                #endif
                throw NSError(domain: domain, code: 1)
            }

            return password
        }

    }

}
