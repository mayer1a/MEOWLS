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
    func logout(completion: @escaping (String?) -> Void)
    func refreshToken(isSilent: Bool)
    func reloadCredentials() async throws
    func forceLogout()

}

extension User: UserAuthorization {

    public func login(with phone: String, accessToken: String, completion: @escaping ParameterClosure<UserAuthError?>) {
        changeUserToken(accessToken, on: APIResourceService.store)

        Task {
            do {
                try await reloadCredentials()
                try await mergeCart()
                try await mergeFavorites()
                completion(nil)
            } catch {
                completion(error.localizedDescription)
            }
        }
    }

    public func logout(completion: @escaping (String?) -> Void) {
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
    }

    public func refreshToken(isSilent: Bool) {
        apiWrapper.refreshToken { [weak self] response in
            if response.error == nil {
                self?.credentials = response.data
                self?.changeUserToken(response.data?.authentication?.token, on: APIResourceService.store)
            } else {
                self?.forceLogout()
                self?.clearStoredData()
            }
        }
    }

    public func reloadCredentials() async throws {
        guard isAuthorized else {
            throw NSError(domain: "User is unauthorized", code: 0)
        }

        try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, Error>) in

            self?.apiWrapper.user(service: .store) { [weak self] response in
                guard let self else {
                    continuation.resume(with: .failure(NSError(domain: "", code: 0, userInfo: [:])))
                    return
                }
                credentials = response.data

                continuation.resume()
            }
        }
    }

    private func mergeCart() async throws {
    }

    private func mergeFavorites() async throws {
    }

    private func clearStoredData() {
        cleanCurrentUserAccessData()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
}
