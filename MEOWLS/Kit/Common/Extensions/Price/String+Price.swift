//
//  String+Price.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import Foundation

public extension String {

    var asDecimal: Decimal {
        guard let value = Decimal(string: self) else {
            return Decimal(0)
        }
        return value
    }

    func asPrice(multiply times: Int? = 1) -> String? {
        guard let value = Decimal(string: self), value > 0 else {
            return nil
        }
        return (value * Decimal(times ?? 1)).asPrice
    }

    func asPrice(minimumFractionDigit: Int) -> String? {
        guard let value = Decimal(string: self) else {
            return nil
        }
        return value.asFractionPrice(minimumFractionDigit: minimumFractionDigit)
    }

}
