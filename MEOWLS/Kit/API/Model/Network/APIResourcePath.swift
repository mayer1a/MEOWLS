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

    // MARK: - Category

    case category(String)

    // MARK: - Sale

    case sales
    case sale(String)

    // MARK: - DESCRIPTION

    public var description: String {
        switch self {
        case .cities: return "api/\(apiVersion)/cities/"

        case .signUp: return "api/\(apiVersion)/users/create/"
        case .signIn: return "api/\(apiVersion)/users/login/"
        case .user: return "api/\(apiVersion)/users/"
        case .updateUser: return "api/\(apiVersion)/users/edit/"
        case .refreshToken: return "api/\(apiVersion)/users/refresh_token/"
        case .logout: return "api/\(apiVersion)/users/logout/"
        case .deleteProfile: return "api/\(apiVersion)/users/delete/"
        case .userAddress: return "api/\(apiVersion)/users/address/"

        case .favorites: return "api/\(apiVersion)/favorites"
        case .markFavorite: return "api/\(apiVersion)/star/"
        case .unmarkFavorite: return "api/\(apiVersion)/unstar/"
        case .favoritesCount: return "api/\(apiVersion)/favorites/count/"

        case .banners: return "api/\(apiVersion)/main_page/"

        case .search: return "api/\(apiVersion)/search/suggestions"

        case .category(let id): return "/api/\(apiVersion)/categories?category_id=\(id)"

        case .sales: return "api/\(apiVersion)/sales"
        case .sale(let id): return "api/\(apiVersion)/sales/\(id)"

        }
    }

    private var apiVersion: String {
        AppConstants.apiVersion
    }

}
