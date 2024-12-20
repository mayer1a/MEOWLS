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
    private var user: UserRegion & UserAuthorization & UserStore
    private lazy var regionService: RegionServiceProtocol = {
        Container.shared.regionService.resolve(.init(viewController: viewController, currentRegion: user))
    }()
    private var isRegionSelected: Bool {
        user.currentRegion != nil
    }

    init(user: UserAuthorization & UserRegion & UserStore) {
        self.user = user
    }

    func viewDidLoad(in viewController: UIViewController?) {
        self.viewController = viewController
        selectRoute()
        sendAnalyticsEvents()
    }

    func viewDidAppear() {
        isLoading = true
    }

    private func sendAnalyticsEvents() {
    }

    private func selectRoute() {
        if isRegionSelected {
            showRoute = .mainFlow
        } else {
            showRegionSelectionFlow()
        }
    }

    private func showRegionSelectionFlow() {
        regionService.showRegionSelection(supposeRegion: true, forceregionsLoad: false) { [weak self] in
            self?.showRoute = .mainFlow
        }
    }

}
