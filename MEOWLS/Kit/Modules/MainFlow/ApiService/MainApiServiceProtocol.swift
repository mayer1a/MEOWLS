//
//  MainApiServiceProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import Foundation

protocol MainApiServiceProtocol {

    typealias Model = MainModel

    func loadBanners(handler: @escaping ResponseHandler<[MainBanner]>)
    func loadSale(id: String, handler: @escaping ResponseHandler<Sale>)
    func loadCategory(id: String, handler: @escaping ResponseHandler<[Category]>)

}
