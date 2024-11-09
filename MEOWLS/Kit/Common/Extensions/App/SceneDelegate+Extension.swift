//
//  SceneDelegate+Extension.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.06.2024.
//

import UIKit
import Kingfisher
import Factory

extension SceneDelegate {

    static func setupAppearance() {
        let uiNavigationBarAppearance = UINavigationBarAppearance()
        uiNavigationBarAppearance.configureWithOpaqueBackground()
        uiNavigationBarAppearance.shadowColor = nil
        uiNavigationBarAppearance.shadowImage = nil
        uiNavigationBarAppearance.backgroundColor = Colors.Background.backgroundWhite.color
        UINavigationBar.appearance().standardAppearance = uiNavigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = uiNavigationBarAppearance

        let tableHeaderViewFrame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude)
        UITableView.appearance().tableHeaderView = .init(frame: tableHeaderViewFrame)
        UITableView.appearance().sectionHeaderTopPadding = .leastNormalMagnitude

        let appearance = UINavigationBar.appearance()
        appearance.tintColor = Colors.Text.textTertiary.color
        appearance.backIndicatorImage = Images.Navigation.navigationBack.image
        appearance.backIndicatorTransitionMaskImage = Images.Navigation.navigationBack.image

        UITabBarItem.appearance().badgeColor = Colors.Accent.accentPrimary.color
    }

//    func setupFirstLaunchCondition() {
//        let settings = SettingsService.shared
//        let isFirstLaunch = !settings[.isNotFirstLaunch]
//        if isFirstLaunch {
//            settings[.isNotFirstLaunch] = true
//            KeychainManager.common.clear() //Keychain keeps data after app deletion
//        }
//    }

    func setupFactory() {
        Container.shared.manager.defaultScope = .graph
    }

    func setupImageCache() {
        let cache = ImageCache.default
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 1024

        cache.cleanExpiredDiskCache()
        cache.cleanExpiredMemoryCache()
    }

}
