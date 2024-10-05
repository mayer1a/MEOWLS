//
//  KeychainManager.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation
import Security

public final class KeychainManager: KeychainManagerProtocol {

    private let service: String

    fileprivate init(service: String) {
        self.service = service
    }

    public static var common: KeychainManagerProtocol {
        #if Store
            return KeychainManager(service: "com.meowls.store")
        #else
            return KeychainManager(service: "com.meowls.pos")
        #endif
    }

    public var deviceId: String? {
        get {
            return self[.deviceId]
        }
        set {
            self[.deviceId] = newValue
        }
    }

    public var phoneNumber: String? {
        get {
            return self[.phoneNumber]
        }
        set {
            self[.phoneNumber] = newValue
        }
    }

    public func clear() {
        #if Store
            delete(account: APIResourceService.store.rawValue)
        #else
            delete(account: APIResourceService.pos.rawValue)
        #endif

        AccountKey.allCases.forEach { account in
            delete(account: account.rawValue)
        }
    }

    public func clear(keys: [String]) {
        keys.forEach { key in
            delete(account: key)
        }
    }

}

// MARK: - AccountKey

private extension KeychainManager {

    enum AccountKey: String, CaseIterable {
        case accessToken
        case phoneNumber
        case pincode
        case fingerprintAllowed
        case deviceId
        case serverDeviceId
    }

}

// MARK: - Generics. Get/Set/Subscript

public extension KeychainManager {

    func getValue<C: Codable>(forKey key: String) -> C? {
        guard let data = data(forAccount: key) else {
            return nil
        }

        let value = (try? JSONDecoder().decode(Archive<C>.self, from: data))?.value

        return value
    }

    func set<C: Codable>(value newValue: C?, forKey key: String) {
        if let newValue {
            guard let data = try? JSONEncoder().encode(Archive(value: newValue)) else {
                return
            }

            save(data: data, forAccount: key)
        } else {
            delete(account: key)
        }
    }

}

// MARK: - Private

private extension KeychainManager {

    func delete(account: String) {
        do {
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrService as String: service,
                                        kSecAttrAccount as String: account,
                                        kSecAttrSynchronizable as String: kSecAttrSynchronizableAny]

            try delete(query)

        } catch KeychainError.ItemNotFound {
            // Ignore this error.
        } catch let error {
            debugPrint("deleteAccount error: \(error)")
        }
    }

    func data(forAccount account: String) -> Data? {
        do {
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrService as String: service,
                                        kSecAttrAccount as String: account,
                                        kSecReturnData as String: kCFBooleanTrue as CFTypeRef]

            let result = try load(query)

            return result as? Data

        } catch KeychainError.ItemNotFound {
            // Ignore this error, simply return nil.
            return nil

        } catch let error {
            debugPrint("dataFor error: \(error)")
            return nil
        }
    }

    func save(data: Data, forAccount account: String) {
        do {
            delete(account: account)

            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrService as String: service,
                                        kSecAttrAccount as String: account,
                                        kSecValueData as String: data,
                                        kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked]

            try save(query)

        } catch let error {
            debugPrint("saveData error: \(error)")
        }
    }

    func save(_ attributes: [String: Any]) throws {
        var result: AnyObject?
        let status = SecItemAdd(attributes as CFDictionary, &result)

        if let error = KeychainError.errorFromOSStatus(status) {
            throw error
        }
    }

    func load(_ query: [String: Any]) throws -> AnyObject? {
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if let error = KeychainError.errorFromOSStatus(status) {
            throw error
        }

        return result
    }

    func delete(_ query: [String: Any]) throws {
        let status = SecItemDelete(query as CFDictionary)

        if let error = KeychainError.errorFromOSStatus(status) {
            throw error
        }
    }

    struct Archive<C: Codable>: Codable {
        let value: C
    }

    private subscript<C: Codable>(key: AccountKey) -> C? {
        get {
            return getValue(forKey: key.rawValue)
        }
        set {
            set(value: newValue, forKey: key.rawValue)
        }
    }

}
