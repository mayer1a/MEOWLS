//
//  UserAccess.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public protocol UserAccess {

    var isAuthorized: Bool { get }
    var tokenExpired: Bool { get }

    func accessToken(_ service: APIResourceService) -> String?
    func changeUserToken(_ token: String?, on service: APIResourceService)

}

extension User: UserAccess {

    public var isAuthorized: Bool {
        settingsService[.isUserAuthorized]
    }

    public var tokenExpired: Bool {
        guard let tokenExpireDate = self.credentials?.authentication?.expiresAt else {
            return false
        }

        return Date() > tokenExpireDate
    }

    public func accessToken(_ service: APIResourceService) -> String? {
        UserTokenService.shared.getToken(service)
    }

    public func cleanCurrentUserAccessData() {
        UserTokenService.shared.cleanAll()
    }

    public func changeUserToken(_ token: String?, on service: APIResourceService) {
        UserTokenService.shared.changeToken(token, on: service)
    }

}

/// Separate class for caching and working with token, singleton
private class UserTokenService {

    static let shared = UserTokenService()

    private init() {}

    // Data is cached until reboot
    private var store: [String: String?] = [:]

    private lazy var keychainManager: KeychainManagerProtocol = KeychainManager.common

    func getToken(_ service: APIResourceService) -> String? {
        let storedToken = store[service.rawValue]

        if let storedToken {
            return storedToken.map({ String(format: "Token %@", $0) })
        }

        let token: String? = keychainManager.getValue(forKey: service.rawValue)

        if token != nil {
            store[service.rawValue] = token
        }

        return token.map({ String(format: "Token %@", $0) })
    }

    // Put the data into cache and keychain
    func changeToken(_ token: String?, on service: APIResourceService) {
        store[service.rawValue] = token
        keychainManager.set(value: token, forKey: service.rawValue)
    }

    func cleanAll() {
        store.removeAll()
    }

}
