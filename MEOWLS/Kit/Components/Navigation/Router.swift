//
//  Router.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import UIKit
import Factory

public final class Router {

    /// An intro screen that is visually consistent and follows immediately after the launchscreen
    public static func introViewController() -> UIViewController {
        resolve(\.introBuilder).build(with: .init())
    }

    #if Store

    public static func showMainController(atTab tab: RootTab = .defaultTab) {
        UIApplication.shared.hideKeyboard()

        let rootTabController = RootTabController()
        rootTabController.selectedIndex = tab.rawValue
        show(rootController: rootTabController)
    }

    #else

    public static func showMainController(atTab tab: RootTab = .defaultTab) {
        UIApplication.shared.hideKeyboard()

        let rootTabController: UITabBarController

        if let rootController = UIApplication.shared.keyWindow?.rootViewController as? RootTabController {
            // Otherwise the modal window is held by the controller
            rootTabController = rootController
        } else {
            rootTabController = RootTabController()
        }

        rootTabController.selectedIndex = tab.rawValue
        show(rootController: rootTabController)
    }

    #endif

    /// Region selection screen
    public static func regionViewController(with inputModel: RegionModel.InputModel) -> UINavigationController? {
        let builder = resolve(\.regionBuilder)
        let viewController = builder.build(with: inputModel)

        return viewController as? UINavigationController
    }

    #if Store

    public static func showAuthorization() {
    }

    #endif

    // MARK: - Window switches

    public static func isMainControllerAtRoot() -> Bool {
        UIApplication.shared.keyWindow?.rootViewController is RootTabController
    }

    // MARK: - Private

    private static func show(rootController: UIViewController, animation: Bool = true, completion: VoidClosure? = nil) {
        if let window = UIApplication.shared.keyWindow {
            // Otherwise the modal window is held by the controller
            window.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
            window.rootViewController = rootController

            let options: UIView.AnimationOptions = [.transitionCrossDissolve, .allowAnimatedContent]
            UIView.transition(with: window, duration: animation ? 0.3 : 0, options: options, animations: {}) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }

}

