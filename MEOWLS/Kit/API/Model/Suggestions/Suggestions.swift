//
//  Suggestions.swift
//  MEOWLS
//
//  Created by Artem Mayer on 09.08.2024.
//

import Foundation

public struct Suggestions: Codable {

    public let id: String?
    public let text: String
    public let gender: UserCredential.Gender?
    public let highlightedText: String

    enum CodingKeys: String, CodingKey {
        case id, text, gender
        case highlightedText = "highlighted_text"
    }

}
