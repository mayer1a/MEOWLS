//
//  APIResourcePath.swift
//  MEOWLS
//
//  Created by Artem Mayer on 11.09.2024.
//

import Foundation

public enum APIResourcePath: CustomStringConvertible {

    // MARK: - Region

    case cities

    // MARK: - User
    
    case signUp
    case signIn
    case user
    case updateUser
    case refreshToken
    case logout
    case deleteProfile
    case userAddress

    // MARK: - Favorites

    case favorites
    case markFavorite
    case unmarkFavorite
    case favoritesCount

    // MARK: - Main

    case banners

    // MARK: - Search

    case search
    case popularSearches

    // MARK: - Catalogue

    case category(String)
    case products

    // MARK: - Sale

    case sales
    case sale(String)

    // MARK: - Static path

    case deliveryInfo
    case refundInfo
    case userAgreementInfo
    case privacyPolicyInfo
    case contactsInfo

    // MARK: - DESCRIPTION

    public var description: String {
        switch self {
        case .cities: return "api/\(apiVersion)/cities"

        case .signUp: return "api/\(apiVersion)/users/create"
        case .signIn: return "api/\(apiVersion)/users/login"
        case .user: return "api/\(apiVersion)/users"
        case .updateUser: return "api/\(apiVersion)/users/edit"
        case .refreshToken: return "api/\(apiVersion)/users/refresh_token"
        case .logout: return "api/\(apiVersion)/users/logout"
        case .deleteProfile: return "api/\(apiVersion)/users/delete"
        case .userAddress: return "api/\(apiVersion)/users/address"

        case .favorites: return "api/\(apiVersion)/favorites"
        case .markFavorite: return "api/\(apiVersion)/favorites/star"
        case .unmarkFavorite: return "api/\(apiVersion)/favorites/unstar"
        case .favoritesCount: return "api/\(apiVersion)/favorites/count"

        case .banners: return "api/\(apiVersion)/main_page"

        case .search: return "api/\(apiVersion)/search/suggestions"
        case .popularSearches: return "api/\(apiVersion)/search/popular"

        case .category(let id): return "/api/\(apiVersion)/categories?category_id=\(id)"
        case .products: return "/api/\(apiVersion)/products"

        case .sales: return "api/\(apiVersion)/sales"
        case .sale(let id): return "api/\(apiVersion)/sales/\(id)"

        case .deliveryInfo: return "\(APIResourceService.staticHost())/delivery"
        case .refundInfo: return "\(APIResourceService.staticHost())/refund"
        case .userAgreementInfo: return "\(APIResourceService.staticHost())/user-agreement"
        case .privacyPolicyInfo: return "\(APIResourceService.staticHost())/privacy-policy"
        case .contactsInfo: return "\(APIResourceService.staticHost())/contacts"

        }
    }

    private var apiVersion: String {
        AppConstants.apiVersion
    }

}
