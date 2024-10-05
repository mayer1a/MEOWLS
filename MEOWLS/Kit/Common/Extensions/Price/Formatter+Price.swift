//
//  Formatter+Price.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import Foundation

public extension Formatter {

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        let language: String? = SettingsService.shared[.language]
        formatter.locale = Locale(identifier: language ?? "ru_RU")
        let currencyCode = "RUB"
        formatter.currencyCode = currencyCode

        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        return formatter
    }()

    static let signedAmountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        let language: String? = SettingsService.shared[.language]
        formatter.locale = Locale(identifier: language ?? "ru_RU")
        let currencyCode = "RUB"
        formatter.currencyCode = currencyCode

        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.positivePrefix = "+"
        formatter.negativePrefix = "-"

        return formatter
    }()

}
