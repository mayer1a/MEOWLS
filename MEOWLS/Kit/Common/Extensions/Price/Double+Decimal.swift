//
//  Double+Decimal.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import Foundation

public extension Double {

    var asDecimal: Decimal {
        Decimal(self)
    }

}
