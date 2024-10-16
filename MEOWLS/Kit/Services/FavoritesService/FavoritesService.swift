//
//  FavoritesService.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit
import Combine
import Factory

public final class FavoritesService: FavoritesServiceProtocol {

    /// Publisher for favorite toggles
    public let favoritesTogglePublisher = CurrentValueSubject<([FavoriteItem]?, Bool), Never>((nil, false))

    #if Store

    public var amount: Int {
        if user.isAuthorized {
            if isLocalFavorites {
                loadFavorites()
                isLocalFavorites = false
            }

            return favoritesAmount
        } else {
            if !isLocalFavorites {
                isLocalFavorites = true
                favoritesAmount = 0
            }

            return items.count
        }
    }

    private var isLocalFavorites = true
    private var favoritesAmount = 0

    #endif

    private let user: UserAccess
    private let apiWrapper: APIWrapperProtocol

    private var ids: [String] { items.compactMap({ $0.identifier }) }
    private var items: [FavoriteItem] {
        get {
            let savedValue: [FavoriteBox]? = SettingsService.shared[.favorites]
            return savedValue ?? []
        }
        set {
            SettingsService.shared[.favorites] = newValue.map { item in
                FavoriteBox(identifier: item.identifier, starred: item.starred)
            }
        }
    }

    /// Caching is used only for the authorized user, so as not to refresh the page when the status changes
    private var favoriteCache = [String: Bool]()

    fileprivate init(user: UserAccess, apiWrapper: APIWrapperProtocol) {
        self.user = user
        self.apiWrapper = apiWrapper
    }

    public func toggle(item: FavoriteItem, completion: ToogleCompletion? = nil) -> Bool {
        let toggled = !self.isFavorite(item: item)

        guard user.isAuthorized else {
            mark(item: item, favorite: toggled)
            favoritesTogglePublisher.send(([item], toggled))
            completion?(toggled)
            return toggled
        }

        sendMarkItems([item], isMarked: toggled) { [weak self] (error, code) in
            guard let self else { return }

            if let code, code >= 200, code < 300 {
                self.cache(items: [item], favorite: toggled)
                self.favoritesTogglePublisher.send(([item], toggled))

                #if Store
                    self.setupAmount(favorite: toggled)
                #endif
                completion?(toggled)

            } else {
                completion?(!toggled)
            }
        }

        return toggled
    }

    public func isFavorite(item: FavoriteItem) -> Bool {
        if user.isAuthorized {
            return favoriteCache[item.identifier] ?? item.starred ?? false
        } else {
            return items.contains(where: { $0.identifier == item.identifier })
        }
    }

    public func merge() async throws {
        guard user.isAuthorized else {
            let domain = "com.meowls.store.favoritesService"
            throw NSError(domain: domain, code: 401, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
        }

        favoriteCache = [String: Bool]()

        try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, Error>) in

            guard let self else {
                let domain = "com.meowls.store.favoritesService"
                let error = "Internal withCheckedThrowingContinuation error"
                let nsError = NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey: error])
                continuation.resume(with: .failure(nsError))
                return
            }

            sendMarkItems(items, isMarked: true) { (error, code) in
                if error != nil || code != nil {
                    let domain = NSURLErrorDomain
                    let error = error ?? ""
                    let code = code ?? 0
                    let nsError = NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: error])
                    continuation.resume(with: .failure(nsError))
                }
            }
        }
    }

}

public extension FavoritesService {

    struct FavoriteBox: Identifiable & Favoritable & Codable {
        public let identifier: String
        public let starred: Bool?
    }

}

private extension FavoritesService {

    func mark(item: FavoriteItem, favorite isFavorite: Bool) {
        #if Store
            favoritesAmount = items.count
        #endif

        if isFavorite {
            items.append(item)
        } else {
            items.removeAll(where: { $0.identifier == item.identifier })
        }

        #if Store
            setupAmount(favorite: isFavorite)
        #endif
    }

    /// In order not to refresh the page once again, after adding/removing from favorites made cache
    func cache(items: [FavoriteItem], favorite: Bool? = nil) {
        items.forEach { favoriteCache[$0.identifier] = favorite ?? $0.starred }
    }

}

#if Store

private extension FavoritesService {

    func setupAmount(favorite isFavorite: Bool) {
        if isFavorite {
            favoritesAmount += 1
        } else if favoritesAmount > 0 {
            favoritesAmount -= 1
        }

        setupBadgeValue()
    }

    func setupBadgeValue() {
        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? RootTabController {
            tabController.addBadgeValue(tab: .favorites, value: favoritesAmount)
        }
    }

    func loadFavorites() {
        apiWrapper.favoritesCount { [weak self] response in
            if let count = response.data?.count {
                self?.favoritesAmount = count
                self?.setupBadgeValue()
            }
        }
    }

}

#endif

private extension FavoritesService {

    func sendMarkItems(_ items: [FavoriteItem], isMarked: Bool, completion: ErrorCompletion?) {
        apiWrapper.toggleFavorite(items: items, isFavorite: true) { response in
            completion?(response.error, response.code)
        }
    }

}

// MARK: - Register container

extension Container {

    var favoritesService: Factory<any FavoritesServiceProtocol> {
        self {
            FavoritesService(user: resolve(\.user), apiWrapper: resolve(\.apiWrapper))
        }
        .singleton
    }

}


