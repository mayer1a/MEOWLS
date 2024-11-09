//
//  RootTab.swift
//  MEOWLS
//
//  Created by Artem Mayer on 19.10.2024.
//

#if Store

import UIKit

public enum RootTab: Int, CaseIterable {

    case main
    case catalogue
    case cart
    case favorites
    case profile

    public static var defaultTab: RootTab {
        .main
    }

    public var title: String {
        switch self {
        case .main:
            return Strings.RootTabBar.main

        case .catalogue:
            return Strings.RootTabBar.catalogue

        case .cart:
            return Strings.RootTabBar.cart

        case .favorites:
            return Strings.RootTabBar.favorites

        case .profile:
            return Strings.RootTabBar.profile

        }
    }

    public var image: UIImage {
        switch self {
        case .main:
            return Images.Tabs.tabMain.image

        case .catalogue:
            return Images.Tabs.tabCatalog.image

        case .cart:
            return Images.Tabs.tabCart.image

        case .favorites:
            return Images.Tabs.tabFavorites.image

        case .profile:
            return Images.Tabs.tabProfile.image

        }
    }

}

#endif
