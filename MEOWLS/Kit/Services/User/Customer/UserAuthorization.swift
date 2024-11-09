//
//  UserAuthorization.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import UIKit

public protocol UserAuthorization {

    typealias UserAuthError = String

    func login(with phone: String, accessToken: String, completion: @escaping ParameterClosure<UserAuthError?>)
    func logout(completion: @escaping ParameterClosure<String?>)
    func refreshToken(isSilent: Bool, with completion: @escaping ParameterClosure<String?>)
    func refreshToken() async throws
    func reloadCredentials() async throws
    func forceLogout()

}

extension User: UserAuthorization {

    public func login(with phone: String, accessToken: String, completion: @escaping ParameterClosure<UserAuthError?>) {
        changeUserToken(accessToken, on: APIResourceService.store)

        keychainManager.phoneNumber = phone
        settingsService[.isUserAuthorized] = true

        Task {
            do {
                try await mergeFavorites()
                try await mergeCart()
                try await reloadCredentials()

                DispatchQueue.main.async { [completion] in
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async { [completion] in
                    completion(error.localizedDescription)
                }
            }
        }
    }

    public func logout(completion: @escaping ParameterClosure<String?>) {
        apiWrapper.logout(service: .store) { [weak self] response in
            if response.error == nil {
                self?.forceLogout()
                completion(nil)
            } else {
                completion(response.error ?? "Unknown error")
            }
        }
    }

    public func forceLogout() {
        credentials = nil
        clearStoredData()
        WebKitCacheCleaner.cleanCache()
    }

    public func refreshToken(isSilent: Bool, with completion: @escaping ParameterClosure<String?>) {
        apiWrapper.refreshToken { [weak self] response in
            if response.error == nil {
                self?.credentials = response.data
                self?.changeUserToken(response.data?.authentication?.token, on: APIResourceService.store)

                completion(nil)
            } else {
                self?.forceLogout()

                if isSilent {
                    let skipAuthHandler: VoidClosure = {
                        Router.showMainController()
                        completion(response.error)
                    }
                    let repeatHandler: VoidClosure = {
                        Router.showAuthorization(completion: skipAuthHandler)
                    }
                    Router.showNetworkError(with: .init(title: Strings.Cart.Empty.unauthorizedAction,
                                                        message: Strings.Alert.NetworkError.unauthorized,
                                                        repeatTitle: Strings.Common.Authorization.login,
                                                        repeatHandler: repeatHandler,
                                                        cancelHandler: skipAuthHandler))
                } else {
                    // Completion when user skip reauth
                    Router.showAuthorization(completion: { completion(response.error) })
                }
            }
        }
    }

    public func refreshToken() async throws {
        guard isAuthorized else {
            return
        }

        try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, Error>) in
            guard let self else {
                let nsError = NSError(domain: "ru.artemayer.meowls.store.userAuthorization", code: 0)
                continuation.resume(with: .failure(nsError))
                return
            }

            apiWrapper.refreshToken { [weak self] response in
                guard let self else {
                    continuation.resume(with: .failure(NSError(domain: "", code: 0)))
                    return
                }
                credentials = response.data
                changeUserToken(response.data?.authentication?.token, on: APIResourceService.store)

                if keychainManager.phoneNumber.isNilOrEmpty {
                    keychainManager.phoneNumber = response.data?.phone
                }

                continuation.resume()
            }
        }
    }

    public func reloadCredentials() async throws {
        guard isAuthorized else {
            return
        }
        
        try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, Error>) in
            guard let self else {
                let domain = "ru.artemayer.meowls.store.userAuthorization"
                let nsError = NSError(domain: domain, code: 0)
                continuation.resume(with: .failure(nsError))
                return
            }

            apiWrapper.user(service: .store) { [weak self] response in
                guard let self else {
                    continuation.resume(with: .failure(NSError(domain: "", code: 0, userInfo: [:])))
                    return
                }
                credentials = response.data

                if keychainManager.phoneNumber.isNilOrEmpty {
                    keychainManager.phoneNumber = response.data?.phone
                }

                continuation.resume()
            }
        }
    }

    private func mergeCart() async throws {
//        try await cartService.uploadLocal()
    }

    private func mergeFavorites() async throws {
        try await favoritesService.merge()
    }

    private func clearStoredData() {
        settingsService.clear(allBut: [.isNotFirstLaunch, .userRegion, .apiResourceServer])
//        cartService.clear()
        favoritesService.clear()
        keychainManager.clear()
        cleanCurrentUserAccessData()
        keychainManager.clear(keys: APIResourceService.allCases.map({ $0.rawValue }))
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
}
