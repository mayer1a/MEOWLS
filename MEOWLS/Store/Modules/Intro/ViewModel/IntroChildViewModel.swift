//
//  IntroChildViewModel.swift
//  Store
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation
import Combine
import Factory

final class IntroChildViewModel: IntroChildViewModelProtocol {

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var showRoutePublisher: Published<IntroModel.Route?>.Publisher { $showRoute }

    @Published private var isLoading: Bool = false
    @Published private var showRoute: IntroModel.Route? = nil
    private weak var viewController: UIViewController?
    private var user: UserRegion & UserAuthorization
    private lazy var regionService: RegionServiceProtocol = {
        Container.shared.regionService.resolve(.init(viewController: viewController, currentRegion: user))
    }()
    private var isRegionSelected: Bool {
        user.currentRegion != nil
    }

    init(user: UserAuthorization & UserRegion) {
        self.user = user
    }

    func viewDidLoad(in viewController: UIViewController?) {
        self.viewController = viewController
        reloadCredentials()
        sendAnalyticsEvents()
    }

    func viewDidAppear() {
        isLoading = true
    }

    private func sendAnalyticsEvents() {
    }

    private func reloadCredentials() {
        Task { [weak self] in
            guard let self else { return }

            try await user.reloadCredentials()

            if isRegionSelected {
                showRoute = .mainFlow
            } else {
                showRegionSelectionFlow()
            }
        }
    }

    private func showRegionSelectionFlow() {
        regionService.showRegionSelection(supposeRegion: true, forceregionsLoad: false) { [weak self] in
            self?.showRoute = .mainFlow
        }
    }

}

extension UIApplication {

    var topViewController: UIViewController? {
        topViewController(from: connectedScenes)
    }

    private func topViewController(from scenes: Set<UIScene>) -> UIViewController? {
        guard let scene = scenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return nil
        }
        return topViewController(rootViewController: scene.windows.first?.rootViewController)
    }

    private func topViewController(rootViewController: UIViewController?) -> UIViewController? {
        if let navigationController = rootViewController as? UINavigationController {
            return topViewController(rootViewController: navigationController.visibleViewController)
        }

        if let tabBarController = rootViewController as? UITabBarController {
            return topViewController(rootViewController: tabBarController.selectedViewController)
        }

        if let presentedViewController = rootViewController?.presentedViewController {
            return topViewController(rootViewController: presentedViewController)
        }

        return rootViewController
    }

}
