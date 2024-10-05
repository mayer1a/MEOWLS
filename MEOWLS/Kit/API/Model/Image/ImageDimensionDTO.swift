//
//  ImageDimensionDTO.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import Foundation

public extension ItemImage {

    struct ImageDimensionDTO: Codable {
        public let width: Int
        public let height: Int
    }

}
