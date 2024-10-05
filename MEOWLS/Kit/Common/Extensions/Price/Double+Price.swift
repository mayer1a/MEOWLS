//
//  Double+Price.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import Foundation

public extension Double {

    var asPrice: String? {
        let price = Decimal(self)
        return Formatter.priceFormatter.string(for: price)
    }

    var asIntegerPrice: String? {
        let formatter = Formatter.priceFormatter
        formatter.maximumFractionDigits = 0
        return formatter.string(for: self)
    }

    func asFractionPrice(minimumFractionDigit: Int) -> String? {
        let formatter = Formatter.priceFormatter
        formatter.minimumFractionDigits = minimumFractionDigit
        return formatter.string(for: self)
    }

}
