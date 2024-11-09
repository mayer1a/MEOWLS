//
//  SettingsService.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public final class SettingsService: SettingsServiceProtocol {

    public static var shared: SettingsServiceProtocol = SettingsService()

    private let userDefaults = UserDefaults.standard

    private init() { }

    public subscript<C: Codable>(key: SettingsKey) -> C? {
        get {
            guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
            let decoder = JSONDecoder()
            let codable = try? decoder.decode(C.self, from: data)
            return codable
        }
        set {
            let encoder = JSONEncoder()
            let codable = try? encoder.encode(newValue)
            userDefaults.set(codable, forKey: key.rawValue)
        }
    }

    public subscript(key: SettingsKey) -> Bool {
        get {
            return userDefaults.bool(forKey: key.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }

    public subscript(key: SettingsKey) -> Date? {
        get {
            return userDefaults.value(forKey: key.rawValue) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }

    public subscript(key: SettingsKey) -> String? {
        get {
            return userDefaults.value(forKey: key.rawValue) as? String
        }
        set {
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }

    public subscript(key: SettingsKey) -> Int? {
        get {
            return userDefaults.value(forKey: key.rawValue) as? Int
        }
        set {
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }

    public subscript(key: SettingsKey) -> Double? {
        get {
            return userDefaults.value(forKey: key.rawValue) as? Double
        }
        set {
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }

    public func clear(allBut cases: [SettingsKey] = []) {
        SettingsKey.allCases.forEach {
            if !cases.contains($0) {
                userDefaults.removeObject(forKey: $0.rawValue)
            }
        }
    }

    public func clear(_ key: SettingsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    public func hasValue(for key: SettingsKey) -> Bool {
        userDefaults.value(forKey: key.rawValue) != nil
    }

}
