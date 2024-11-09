//
//  typealiases.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

// MARK: - Design system

public typealias HEXColor = String

// MARK: - API

public typealias ProductsResponse = ResponseHandler<PaginationResponse<Product>>
public typealias SalesResponse = ResponseHandler<PaginationResponse<Sale>>
