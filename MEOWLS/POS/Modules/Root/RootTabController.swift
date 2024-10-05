//
//  RootTabController.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import UIKit
import Factory

final class RootTabController: NiblessTabBarController {

    enum Tab: Int, CaseIterable {
        case main
        case catalogue
        case cart
        case favorites
        case profile

        static var defaultTab: Tab {
            .main
        }

        var title: String {
            switch self {
            case .main:
                return Strings.RootTabBar.main

            case .catalogue:
                return Strings.RootTabBar.catalogue

            case .cart:
                return Strings.RootTabBar.cart

            case .favorites:
                return Strings.RootTabBar.favorites

            case .profile:
                return Strings.RootTabBar.profile

            }
        }

        var image: UIImage {
            switch self {
            case .main:
                return UIImage(resource: .details)
                // UIImage(resource: .mainTab)

            case .catalogue:
                return UIImage(resource: .details)
                // UIImage(resource: catalogueTab)

            case .cart:
                return UIImage(resource: .details)
                // UIImage(resource: cartTab)

            case .favorites:
                return UIImage(resource: .details)
                // UIImage(resource: heartUnchecked)

            case .profile:
                return UIImage(resource: .details)
                // UIImage(resource: profileTab)

            }
        }
    }

//    var footerBanner: LegacyBanner? {
//        didSet {
//            if let viewController = selectedViewController {
//                if viewController.childVC() is CustomerProfileViewController {
//                    hideFloatingBanner(on: viewController)
//                } else {
//                    updateBottomContainer(viewController)
//                }
//            }
//        }
//    }

//    private var cart: CartServiceProtocol = CartService.shared

    override init() {
        super.init()

        setupTabs()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        setupTabBar()

        // Subscribe to the banner to track if it exists.
        // This is necessary, since the screen may already appear, but there is no banner yet
        // debounce to wait for it to appear
//        bannerWorker.floatingBanner
//            .subscribe(on: MainScheduler.instance)
//            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
//            .subscribe { [weak self] banner in
//                guard let self else {
//                    return
//                }
//
//                self.footerBanner = banner.element.unsafelyUnwrapped
//            }
//            .disposed(by: bag)

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

//        cart.get { [weak self] _ in
//            if let self {
//                self.addBadgeValue(tab: .cart, value: self.cart.amount)
//            }
//        }
    }

    func popToTop(tab: Tab) {
        guard
            let count = viewControllers?.count, count > tab.rawValue,
            let nav = viewControllers?[tab.rawValue] as? UINavigationController,
            nav.isViewLoaded
        else {
            return
        }

        nav.popToRootViewController(animated: false)
    }

    func select(tab: Tab) {
        selectedIndex = tab.rawValue
    }

    func addBadgeValue(tab: Tab, value: Int) {
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

//    private func updateBottomContainer(_ viewController: UIViewController) {
//        guard let view = viewController.view, viewController.view.superview != nil else {
//            return
//        }
//
//        if footerBanner != nil {
//            // If we have a banner, then we make an indent from the edge in the size of the tab bar to add it there
//            view.snp.remakeConstraints { make in
//                make.left.top.right.equalToSuperview()
//                make.bottom.equalToSuperview().offset(-tabBar.frame.size.height)
//            }
//            bannerWorker.registerMainView(viewController)
//        } else {
//            // If there is no banner, then remove all indents
//            view.snp.remakeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//        }
//    }

    private func setupTabs() {
        var viewControllers = [UIViewController]()
        let tabs = Tab.allCases

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
                break
//                @Injected var builder: MainBuilderProtocol
//                let mainVC = builder.build(.init())
//                navVC.viewControllers = [mainVC]

            case .catalogue:
                break
//                navVC.viewControllers = [CategoriesViewController.controller()]

            case .cart:
                break
//                @Injected var builder: DomainCartBuilderProtocol
//                let vc = builder.build(.init())
//                navVC.viewControllers = [vc]

            case .favorites:
                break
//                navVC.viewControllers = [FavoritesBuilder.build()]

            case .profile:
                break
//                @Injected var builder: CustomerProfileBuilderProtocol
//                let profileVC = builder.build(.init())
//                navVC.viewControllers = [profileVC]

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
        let navVc = viewControllers?[Tab.cart.rawValue] as? UINavigationController

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

//    private func hideFloatingBanner(on viewController: UIViewController) {
//        for subview in self.view.subviews where subview is FloatingBannerView {
//            subview.isHidden = true
//        }
//
//        guard let view = viewController.view, viewController.view.superview != nil else {
//            return
//        }
//
//        view.snp.remakeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }

    func updateLocalization() {
        setupTabs()
    }

}

extension RootTabController: UITabBarControllerDelegate {

    public func tabBarController(_ tabBarController: UITabBarController,
                                 shouldSelect viewController: UIViewController) -> Bool {
        true
    }

//    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if let tab = Tab(rawValue: tabBarController.selectedIndex), tab != .profile {
//            for subview in view.subviews where subview is FloatingBannerView {
//                subview.isHidden = false
//            }
//
//            updateBottomContainer(viewController)
//        } else {
//            hideFloatingBanner(on: viewController)
//        }
//    }

}
