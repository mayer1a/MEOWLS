//
//  SettingsServiceProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 16.09.2024.
//

import Foundation

public protocol SettingsServiceProtocol {

    subscript<C: Codable>(key: SettingsKey) -> C? { get set }
    subscript(key: SettingsKey) -> Bool { get set }
    subscript(key: SettingsKey) -> Date? { get set }
    subscript(key: SettingsKey) -> String? { get set }
    subscript(key: SettingsKey) -> Int? { get set }
    subscript(key: SettingsKey) -> Double? { get set }

    func clear(allBut cases: [SettingsKey])
    func clear(_ key: SettingsKey)
    func hasValue(for key: SettingsKey) -> Bool

}
