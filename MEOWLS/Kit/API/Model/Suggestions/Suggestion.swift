//
//  Suggestion.swift
//  MEOWLS
//
//  Created by Artem Mayer on 09.08.2024.
//

import Foundation

public struct Suggestion: Codable {

    public let id: String
    public let text: String
    public let gender: UserCredential.Gender?
    public let highlightedText: String

    enum CodingKeys: String, CodingKey {
        case id, text, gender
        case highlightedText = "highlighted_text"
    }

    public init(id: String = UUID().uuidString, text: String, gender: UserCredential.Gender?, highlightedText: String) {
        self.id = id
        self.text = text
        self.gender = gender
        self.highlightedText = highlightedText
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.text = try container.decode(String.self, forKey: .text)
        self.gender = try? container.decodeIfPresent(UserCredential.Gender.self, forKey: .gender) ?? nil
        self.highlightedText = try container.decode(String.self, forKey: .highlightedText)
    }

}
