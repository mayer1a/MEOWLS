//
//  Strings+Localizable.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import Foundation

extension String {

    func localized() -> String {
        localizedInPreferredBundle(table: nil)
    }

    func localizedFormat() -> String {
        NSLocalizedString(localized(), comment: "")
    }

    func localized(for flow: String) -> String {
        localizedInPreferredBundle(table: flow)
    }

    func localizedFormat(for flow: String) -> String {
        NSLocalizedString(localized(for: flow), comment: "")
    }

    func localizedInPreferredBundle(table: String?) -> String {
        guard let code = SettingsService.shared[.localizationCode] ?? NSLocale.preferredLanguageCode else {
            return localizedInMainBundle()
        }
        let bundle = Bundle().preferredBundle(with: code)
        return localizedInBundle(bundle, table: table)
    }

    private func localizedInMainBundle() -> String {
        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    private func localizedInBundle(_ bundle: Bundle, table: String? = nil) -> String {
        bundle.localizedString(forKey: self, value: nil, table: table)
    }

}

extension NSLocale {

    static var preferredLanguageCode: String? {
        guard let language = Locale.preferredLanguages.first else {
            return nil
        }
        let languageInfo = Locale.components(fromIdentifier: language)
        return languageInfo["kCFLocaleLanguageCodeKey"]
    }

}

extension Bundle {

    func preferredBundle(with code: String) -> Bundle {
        if let path = Bundle.main.path(forResource: code, ofType: "lproj") {
            return Bundle(path: path) ?? Bundle.main
        } else {
            return Bundle.main
        }
    }

}
