//
//  PaginatorProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 19.10.2024.
//

import Foundation

public protocol PaginatorProtocol {

    var nextParameters: [String: Any] { get }
    var hasNextPage: Bool { get }
    var isFirstPage: Bool { get }

    init(pageSize: Int)

    func pagination<D: Codable>(with response: PaginationResponse<D>)
    func reset()

}
