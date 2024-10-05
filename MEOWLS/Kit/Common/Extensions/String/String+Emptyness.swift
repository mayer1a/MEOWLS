//
//  String+Emptyness.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public extension String {

    var isWhitespacesOnly: Bool {
        trimmingCharacters(in: .whitespaces).isEmpty
    }

}
