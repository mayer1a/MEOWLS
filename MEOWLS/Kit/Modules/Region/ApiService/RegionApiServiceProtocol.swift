//
//  RegionApiServiceProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.09.2024.
//

import Foundation

protocol RegionApiServiceProtocol {

    func getCitiesGeoIP(handler: @escaping ResponseHandler<[City]>)

}
