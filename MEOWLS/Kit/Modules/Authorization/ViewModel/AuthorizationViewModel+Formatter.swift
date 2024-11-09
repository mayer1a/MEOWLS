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
        base.foregroundColor = Colors.Text.textSecondary.color

        var userAgreement = AttributedString(Strings.Common.Authorization.Agreement.userAgreement)
        userAgreement.foregroundColor = Colors.Accent.accentPrimary.color
        userAgreement.link = URL(string: APIResourcePath.userAgreementInfo.description)

        var end = AttributedString(Strings.Common.Authorization.Agreement.end)
        end.foregroundColor = Colors.Text.textSecondary.color

        var privacyPolicy = AttributedString(Strings.Common.Authorization.Agreement.privacy)
        privacyPolicy.foregroundColor = Colors.Accent.accentPrimary.color
        privacyPolicy.link = URL(string: APIResourcePath.privacyPolicyInfo.description)

        return base + userAgreement + end + privacyPolicy
    }

}
