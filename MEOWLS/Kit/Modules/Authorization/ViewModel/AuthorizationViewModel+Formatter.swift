//
//  AuthorizationViewModel+Formatter.swift
//  MEOWLS
//
//  Created by Artem Mayer on 30.10.2024.
//

import UIKit

extension AuthorizationViewModel {

    static func getAgreementText() -> AttributedString {
        var base = AttributedString(Strings.Common.Authorization.Agreement.start)
        base.foregroundColor = UIColor(resource: .textSecondary)

        var userAgreement = AttributedString(Strings.Common.Authorization.Agreement.userAgreement)
        userAgreement.foregroundColor = UIColor(resource: .accentPrimary)
        userAgreement.link = URL(string: APIResourcePath.userAgreementInfo.description)

        var end = AttributedString(Strings.Common.Authorization.Agreement.end)
        end.foregroundColor = UIColor(resource: .textSecondary)

        var privacyPolicy = AttributedString(Strings.Common.Authorization.Agreement.privacy)
        privacyPolicy.foregroundColor = UIColor(resource: .accentPrimary)
        privacyPolicy.link = URL(string: APIResourcePath.privacyPolicyInfo.description)

        return base + userAgreement + end + privacyPolicy
    }

}
