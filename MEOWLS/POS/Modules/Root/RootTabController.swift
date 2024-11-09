//
//  RootTabController.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import UIKit
import Factory

final class RootTabController: NiblessTabBarController {

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
//                make.directionalEdges.equalToSuperview()
//            }
//        }
//    }

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
                break
//                @Injected var builder: MainBuilderProtocol
//                let mainVC = builder.build(.init())
//                navVC.viewControllers = [mainVC]

            case .tasks:
                break

            case .catalogue:
                break
//                navVC.viewControllers = [CategoriesViewController.controller()]

            case .cart:
                break
//                @Injected var builder: DomainCartBuilderProtocol
//                let vc = builder.build(.init())
//                navVC.viewControllers = [vc]

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
//            make.directionalEdges.equalToSuperview()
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
