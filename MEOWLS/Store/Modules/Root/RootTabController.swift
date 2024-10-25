//
//  RootTabController.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import UIKit
import Factory

final class RootTabController: NiblessTabBarController {

    private var favoritesService = resolve(\.favoritesService)

    override init() {
        super.init()

        setupTabs()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        setupTabBar()
        NotificationCenter.default.addObserver(forName: .refreshAllTabs, object: nil, queue: .main) { [weak self] _ in
            self?.updateLocalization()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateBadge()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func updateBadge() {
        guard
            let nav = selectedViewController as? UINavigationController,
            nav.parent is RootTabController
        else {
            return
        }

        addBadgeValue(tab: .favorites, value: favoritesService.amount)
    }

    func popToTop(tab: RootTab) {
        guard
            let count = viewControllers?.count, count > tab.rawValue,
            let nav = viewControllers?[tab.rawValue] as? UINavigationController,
            nav.isViewLoaded
        else {
            return
        }

        nav.popToRootViewController(animated: false)
    }

    func select(tab: RootTab) {
        selectedIndex = tab.rawValue
    }

    func addBadgeValue(tab: RootTab, value: Int) {
        let strValue: String? = value > 0 ? String(value) : nil

        guard
            let count = viewControllers?.count,
            count > tab.rawValue,
            let con = viewControllers?[tab.rawValue]
        else {
            return
        }

        con.tabBarItem.badgeValue = strValue
    }

    private func setupTabs() {
        var viewControllers = [UIViewController]()
        let tabs = RootTab.allCases

        tabs.forEach { tab in
            let navVC = UINavigationController()
            let tabItem = UITabBarItem()
            tabItem.title = tab.title
            tabItem.image = tab.image
            navVC.tabBarItem = tabItem
            navVC.extendedLayoutIncludesOpaqueBars = true
            navVC.navigationBar.isTranslucent = false
            navVC.navigationBar.isOpaque = true
            navVC.navigationBar.backgroundColor = UIColor(resource: .backgroundWhite)

            switch tab {
            case .main:
                let mainViewController = resolve(\.mainBuilder).build(with: .init())
                navVC.viewControllers = [mainViewController]

            case .catalogue:
                break

            case .cart:
                break

            case .favorites:
                let favoritesViewController = resolve(\.favoritesBuilder).build()
                navVC.viewControllers = [favoritesViewController]
                setupBarShadow(for: navVC.navigationBar)

            case .profile:
                break

            }

            viewControllers.append(navVC)
        }

        self.viewControllers = viewControllers
    }

    private func setupTabBar() {
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.iconColor = UIColor(resource: .iconSecondary)
        tabBarItemAppearance.normal.badgeBackgroundColor = UIColor(resource: .accentPrimary)
        tabBarItemAppearance.normal.badgePositionAdjustment.horizontal = 8
        tabBarItemAppearance.normal.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: UIColor(resource: .textSecondary)
        ]

        tabBarItemAppearance.selected.iconColor = UIColor(resource: .iconPrimary)
        tabBarItemAppearance.selected.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: UIColor(resource: .textPrimary)
        ]

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(resource: .backgroundWhite)
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance

        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil

        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance

        additionalSafeAreaInsets.bottom = 1
        let navVc = viewControllers?[RootTab.cart.rawValue] as? UINavigationController

        if let navigationBar = navVc?.navigationBar  {
            setupBarShadow(for: navigationBar)
        }
        setupBarShadow(for: tabBar)
    }

    private func setupBarShadow(for view: UIView) {
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 12.0
        view.layer.shadowColor = UIColor(resource: .shadowSmall).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }

    func updateLocalization() {
        setupTabs()
    }

}

extension RootTabController: UITabBarControllerDelegate {

    public func tabBarController(_ tabBarController: UITabBarController,
                                 shouldSelect viewController: UIViewController) -> Bool {
        true
    }

}
