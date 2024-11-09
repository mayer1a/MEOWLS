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
    /// Products with a specific description from the cart
    case cartItems
    /// Cart
    case cartFull
    /// List of viewed products
    case viewed
    /// List of selected product IDs
    case favorites
    /// Current ApiResourceServer
    case apiResourceServer

    // System info
    case localizationCode
    case language
}
