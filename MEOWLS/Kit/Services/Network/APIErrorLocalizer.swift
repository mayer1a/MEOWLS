//
//  APIErrorLocalizer.swift
//  MEOWLS
//
//  Created by Artem Mayer on 12.09.2024.
//

import Foundation

/// Локализует собщения об ошибках приходящие с сервера
/// Необходим лишь для тех ошибок, которые требуется показывать пользователю
final class APIErrorLocalizer {

    static func localizeError(message: String) -> String {
        if let result = notFoudItemMessage(for: message) {
            return result
        } else if let result = notEnoughItemMessage(for: message) {
            return result
        } else if let result = regionIsRequiredMessage(for: message) {
            return result
        } else {
            return message
        }
    }

    private static func notFoudItemMessage(for message: String) -> String? {
        let substrings = message.split(separator: " ", omittingEmptySubsequences: true)
        let strings = substrings.map { String($0) }
        let maskArray = ["Not", "found", "items", "for"]
        let maskSet = Set(maskArray)
        let messageSet = Set(strings)
        if maskSet.isSubset(of: messageSet),
            let articleId = strings.last {
            let newMessage = "Товар с артикулом " + articleId + " недоступен для заказа."
            return newMessage
        } else {
            return nil
        }
    }

    private static func notEnoughItemMessage(for message: String) -> String? {
        let substrings = message.split(separator: " ", omittingEmptySubsequences: true)
        let strings = substrings.map { String($0) }
        let maskArray = ["not", "enough", "items", "for"]
        let maskSet = Set(maskArray)
        let messageSet = Set(strings)
        if maskSet.isSubset(of: messageSet),
            strings.count > 5 {
            let articleId = strings[4]
            let newMessage = "Товар с артикулом " + articleId + " недоступен для заказа."
            return newMessage
        } else {
            return nil
        }
    }

    private static func regionIsRequiredMessage(for message: String) -> String? {
        if message == "Region is required" {
            return "Необходмо указать регион"
        } else {
            return nil
        }
    }

}

