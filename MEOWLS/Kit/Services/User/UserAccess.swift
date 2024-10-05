//
//  UserAccess.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public protocol UserAccess {

    func accessToken(_ service: APIResourceService) -> String?

}

extension User: UserAccess {

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

/// отдельный класс для кэширования и работы с токеном, синглтон
private class UserTokenService {

    static let shared = UserTokenService()

    private init() {}

    // кэшируются данные до перезагрузки
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

    // данные кладём в кэш и в кичейн
    func changeToken(_ token: String?, on service: APIResourceService) {
        store[service.rawValue] = token
        keychainManager.set(value: token, forKey: service.rawValue)
    }

    func cleanAll() {
        store.removeAll()
    }

}
