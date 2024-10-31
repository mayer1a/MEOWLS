//
//  WebKitCacheCleaner.swift
//  MEOWLS
//
//  Created by Artem Mayer on 31.10.2024.
//

import WebKit

struct WebKitCacheCleaner {

    private static let domain = "artemayer.ru"

    static func cleanCache() {
        DispatchQueue.main.async {
            clean()
        }
    }

    /// Cleans WebKit cache and cookies to reset authorization in webview when user logs out
    private static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        let dataStore = WKWebsiteDataStore.default()

        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                guard record.displayName.contains(domain) else {
                    return
                }

                dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

}
