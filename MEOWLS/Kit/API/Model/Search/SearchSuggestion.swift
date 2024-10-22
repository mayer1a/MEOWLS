//
//  SearchSuggestion.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.08.2024.
//

import Foundation

public struct SearchSuggestion: Codable {

    public let text: String
    public let additionalText: String?
    public let highlightedTexts: [String]?
    public let redirect: Redirect

    enum CodingKeys: String, CodingKey {
        case text
        case additionalText = "additional_text"
        case highlightedTexts = "highlighted_texts"
        case redirect
    }

}
