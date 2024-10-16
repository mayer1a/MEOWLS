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
    static func introViewController() -> UIViewController {
        resolve(\.introBuilder).build(with: .init())
    }

    #if Store

    static func showMainController(atTab tab: RootTabController.Tab = .defaultTab) {
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

    #else

    static func showMainController(atTab tab: RootTabController.Tab = .defaultTab) {
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

    #if Store

    static func showAuthorization() {
    }

    #endif

    // MARK: - Window switches

    static func isMainControllerAtRoot() -> Bool {
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

