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
            navVC.navigationBar.backgroundColor = Colors.Background.backgroundWhite.color

            switch tab {
            case .main:
                let mainViewController = resolve(\.mainBuilder).build(with: .init())
                navVC.viewControllers = [mainViewController]

            case .catalogue:
                navVC.viewControllers = [Container.shared.underDevelopmentViewBuilder.resolve(tab.title)]
                setupBarShadow(for: navVC.navigationBar)

            case .cart:
                navVC.viewControllers = [Container.shared.underDevelopmentViewBuilder.resolve(tab.title)]
                setupBarShadow(for: navVC.navigationBar)

            case .favorites:
                let favoritesViewController = resolve(\.favoritesBuilder).build()
                navVC.viewControllers = [favoritesViewController]
                setupBarShadow(for: navVC.navigationBar)

            case .profile:
                navVC.viewControllers = [Container.shared.underDevelopmentViewBuilder.resolve(tab.title)]
                setupBarShadow(for: navVC.navigationBar)

            }

            viewControllers.append(navVC)
        }

        self.viewControllers = viewControllers
    }

    private func setupTabBar() {
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.iconColor = Colors.Icon.iconSecondary.color
        tabBarItemAppearance.normal.badgeBackgroundColor = Colors.Accent.accentPrimary.color
        tabBarItemAppearance.normal.badgePositionAdjustment.horizontal = 8
        tabBarItemAppearance.normal.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: Colors.Text.textSecondary.color
        ]

        tabBarItemAppearance.selected.iconColor = Colors.Icon.iconPrimary.color
        tabBarItemAppearance.selected.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: Colors.Text.textPrimary.color
        ]

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = Colors.Background.backgroundWhite.color
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
        view.layer.shadowColor = Colors.Shadow.shadowSmall.color.cgColor
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
