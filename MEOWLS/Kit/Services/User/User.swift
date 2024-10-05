//
//  User.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation
import Alamofire
import Factory

public final class User {

    @LazyInjected(\.apiWrapper) public var apiWrapper

    #if Store

    private let networkManager: NetworkReachabilityManager?
    // Was the user status updated after the application was restarted
    private var userSessionUpdated: Bool = false
    // Avoid making network requests in parallel
    private var onDataRequest: Bool = false

    fileprivate init() {
        networkManager = NetworkReachabilityManager()

        setupReachability()
        updateUserData()
    }

    private func setupReachability() {
        guard let networkManager else { return }

        networkManager.startListening(onQueue: .global(qos: .background)) { [weak self] status in
            guard let self else { return }

            // если мы ранее не обновляли данные в рамках сессии
            if self.userSessionUpdated == false, case .reachable = status {
                // если есть интернет то пытаемся обновить
                self.updateUserData()
            }
        }
    }

    private func updateUserData() {
        guard !onDataRequest else { return }

        onDataRequest = true

        Task { [weak self] in
            guard let self else { return }

            do {
                try await self.reloadCredentials()
                self.userSessionUpdated = true
            } catch {

            }
            self.onDataRequest = false
        }
    }

    #endif

}

// MARK: - Register container

public extension Container {

    var user: Factory<User> {
        self {
            User()
        }.singleton
    }

}
