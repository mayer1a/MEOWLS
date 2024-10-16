//
//  RegionService.swift
//  MEOWLS
//
//  Created by Artem Mayer on 16.09.2024.
//

import UIKit
import Factory

public protocol RegionServiceProtocol {

    func showRegionSelection(supposeRegion: Bool, forceregionsLoad: Bool, completion: VoidClosure?)

}


public final class RegionService: RegionServiceProtocol {

    private weak var viewController: UIViewController?
    private weak var region: UserRegion?
    private let regionAgent: RegionAgentProtocol

    init(viewController: UIViewController?, regionAgent: RegionAgentProtocol, region: UserRegion?) {
        self.viewController = viewController
        self.regionAgent = regionAgent
        self.region = region
    }

    /// If the regions are not loaded yet - load. Otherwise - show the region selection screen
    public func showRegionSelection(supposeRegion: Bool, forceregionsLoad: Bool = false, completion: VoidClosure?) {
        if forceregionsLoad {
            regionAgent.cachedRegions = nil
        }
        if let cachedRegions = regionAgent.cachedRegions {
            showRegionSelection(regions: cachedRegions, selectedRegion: region?.currentRegion, completion: completion)
        } else {
            requestAndShowRegionSelection(supposeRegion: supposeRegion, completion: completion)
        }
    }

    /// supposeRegion - whether to guess the region by geolocation
    private func requestAndShowRegionSelection(supposeRegion: Bool, completion: VoidClosure?) {

        regionAgent.requestCurrentRegion(completion: { [weak self] supposedRegion, regions in
            self?.showRegionSelection(regions: regions,
                                      selectedRegion: self?.region?.currentRegion ?? supposedRegion,
                                      completion: completion)
        }, networkError: { [weak self] _, message in
            self?.viewController?.showNetworkError(message: message, cancelButtonHandler: {
                self?.viewController?.show(warning: Strings.Region.Warning.required) {
                    self?.showRegionSelection(supposeRegion: supposeRegion, completion: completion)
                }
            }, repeatButtonHandler: {
                self?.showRegionSelection(supposeRegion: supposeRegion, completion: completion)
            })
        })
    }

    // MARK: - Dialogs

    /// Region selection dialog
    @discardableResult
    private func showRegionSelection(regions: [City],
                                     selectedRegion: City?,
                                     completion: VoidClosure?) -> UIViewController? {

        let model = RegionModel.InputModel(cities: regions, selectedCity: selectedRegion) { [weak self] selected in
            self?.region?.currentRegion = selectedRegion
            completion?()
        }
        if let nav = Router.regionViewController(with: model) {
            viewController?.present(nav, animated: true, completion: nil)
            return nav.topViewController as? RegionViewController
        }
        return nil
    }

}

// MARK: - Register container

public extension Container {

    struct RegionServiceInput {
        public let viewController: UIViewController?
        public let currentRegion: UserRegion?
    }

    var regionService: ParameterFactory<RegionServiceInput, RegionServiceProtocol> {
        self {
            RegionService(viewController: $0.viewController,
                          regionAgent: resolve(\.regionAgent),
                          region: $0.currentRegion)
        }.unique
    }

}
