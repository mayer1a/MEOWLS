//
//  Decimal+Price.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import Foundation

public extension Decimal {

    var asPrice: String? {
        Formatter.priceFormatter.string(for: self)
    }

    var asSignedAmount: String? {
        Formatter.signedAmountFormatter.string(for: self)
    }

    func asFractionPrice(minimumFractionDigit: Int) -> String? {
        let formatter = Formatter.priceFormatter
        formatter.minimumFractionDigits = minimumFractionDigit
        return formatter.string(for: self)
    }

}
