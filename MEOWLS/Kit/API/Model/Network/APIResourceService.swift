//
//  APIResourceService.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public enum APIResourceService: String, CaseIterable {

    case store
    case pos

    public static var current: Self {
        #if Store
            return .store
        #else
            return .pos
        #endif
    }

    public func baseUrl(_ server: APIResourceServer) -> String {
        switch (self, server) {
        case (.store, .development):
            return StoreServerAddresses.development

        case (.store, .production):
            return StoreServerAddresses.production

        case (.pos, .development):
            return POSServerAddresses.development

        case (.pos, .production):
            return POSServerAddresses.production

        case (_, .custom(let address)):
            return address

        }
    }

    public func server(by baseURL: String) -> APIResourceServer {
        switch (self, baseURL) {
        case (.store, StoreServerAddresses.development):
            return .development

        case (.store, StoreServerAddresses.production):
            return .production

        case (.pos, POSServerAddresses.development):
            return .development

        case (.pos, POSServerAddresses.production):
            return .production

        default:
            return .custom(address: baseURL)
        }
    }

    public func webSite(for server: APIResourceServer) -> String {
        switch (self, server) {
        case (_, .development), (_, .production), (_, .custom):
            return WebSiteAddress.apiSiteHost

        }
    }

    public static func staticHost() -> String {
        return StaticAddress.staticHost
    }

    private struct StoreServerAddresses {
        static let development = "https://api.meowls.artemayer.ru/"//"https://api.dev.meowls.artemayer.ru/"
        static let production = "https://api.meowls.artemayer.ru/"//"https://api.meowls.artemayer.ru/"
    }

    // Пока что один и тот же сервер
    private struct POSServerAddresses {
        static let development = "https://api.meowls.artemayer.ru/"//"https://api.dev.meowls.artemayer.ru/"
        static let production = "https://api.meowls.artemayer.ru/"//"https://api.meowls.artemayer.ru/"
    }

    private struct WebSiteAddress {
        static let apiSiteHost = "www.meowls.artemayer.ru/"
    }

    private struct StaticAddress {
        static let staticHost = "https://static.artemayer.ru"
    }

}
