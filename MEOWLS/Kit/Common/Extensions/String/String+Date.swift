//
//  String+Date.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.10.2024.
//

import Foundation

public extension String {

    var toDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.date(from: self)
    }

}
