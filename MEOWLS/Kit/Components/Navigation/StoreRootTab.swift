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
            return UIImage(resource: .details)

        case .catalogue:
            return UIImage(resource: .details)

        case .cart:
            return UIImage(resource: .details)

        case .favorites:
            return UIImage(resource: .details)

        case .profile:
            return UIImage(resource: .details)

        }
    }

}

#endif
