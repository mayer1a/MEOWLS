//
//  PaginationResponse.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.07.2024.
//

import Foundation

public struct PaginationResponse<D: Codable>: Codable {

    public var results: [D]
    public let paginationInfo: PaginationInfo

}
