//
//  SettingsKey.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public enum SettingsKey: String, CaseIterable {
    case isNotFirstLaunch
    case isUserAuthorized
    case userCredentials
    case userRegion
    case cartItems
    case cartFull
    case viewed
    case favorites
    case apiResourceServer
    case appInstanceId
    case clientId
    case storeAnalyticEventSaveServiceConfig
    case storeAnalyticForcedCollection
    case attributions

    // System info
    case localizationCode
    case language
}
