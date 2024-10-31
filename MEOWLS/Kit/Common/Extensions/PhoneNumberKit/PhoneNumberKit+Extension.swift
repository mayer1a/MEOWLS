//
//  PhoneNumberKit+Extension.swift
//  MEOWLS
//
//  Created by Artem Mayer on 28.10.2024.
//

import PhoneNumberKit

extension PhoneNumberKit {

    func verifyPhoneNumber(_ phoneNumber: String, for region: String) throws -> String {
        let parsedNumber = try parse(phoneNumber, withRegion: region)
        let clearNumber = String(format(parsedNumber, toType: .e164).dropFirst())
        let verified = isValidPhoneNumber(clearNumber, withRegion: region)

        guard verified else {
            throw PhoneNumberError.generalError
        }
        return clearNumber
    }

    func formattedExampleNumber(for region: String) -> String? {
        getFormattedExampleNumber(forCountry: region, withPrefix: false)?
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "[0-9]", with: "9", options: .regularExpression)
    }

}
