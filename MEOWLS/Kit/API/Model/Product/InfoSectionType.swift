//
//  InfoSectionType.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public extension Product.InfoSection {

    enum InfoSectionType: String, Codable {
        case textExpandable = "text_expandable"
        case textModal = "text_modal"
    }

}
