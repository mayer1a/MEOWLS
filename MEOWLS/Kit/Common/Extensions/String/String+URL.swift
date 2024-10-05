//
//  String+URL.swift
//  MEOWLS
//
//  Created by Artem Mayer on 11.09.2024.
//

import Foundation

extension String {

    var toURL: URL? {
        URL(string: self)
    }

}
