//
//  POSRootTab.swift
//  MEOWLS
//
//  Created by Artem Mayer on 19.10.2024.
//

#if POS

import UIKit

public enum RootTab: Int, CaseIterable {

    case main
    case tasks
    case catalogue
    case cart
    case profile

    public static var defaultTab: RootTab {
        .main
    }

    public var title: String {
        switch self {
        case .main:
            return Strings.RootTabBar.main

        case .tasks:
            return Strings.RootTabBar.tasks

        case .catalogue:
            return Strings.RootTabBar.catalogue

        case .cart:
            return Strings.RootTabBar.cart

        case .profile:
            return Strings.RootTabBar.profile

        }
    }

    public var image: UIImage {
        switch self {
        case .main:
            return Images.Tabs.tabMain.image

        case .tasks:
            return Images.Common.info.image

        case .catalogue:
            return Images.Tabs.tabCatalog.image

        case .cart:
            return Images.Tabs.tabCart.image

        case .profile:
            return Images.Tabs.tabProfile.image

        }
    }
}

#endif
