//
//  SaleType.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public extension Sale {

    enum SaleType: String, Codable {
        case online
        case offline
    }

}
