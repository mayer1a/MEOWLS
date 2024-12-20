//
//  UIViewController+Navigation.swift
//  MEOWLS
//
//  Created by Artem Mayer on 17.10.2024.
//

import UIKit

extension UIViewController {

    var isModal: Bool {
        let navVC = navigationController
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navVC?.presentingViewController?.presentedViewController == navVC
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }

    func present(_ viewControllerToPresent: UIViewController, completion: (() -> Void)? = nil) {
        present(viewControllerToPresent, animated: true, completion: completion)
    }

    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func dismiss(completion: (() -> Swift.Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }

    func setShadowOpacity(with value: Float) {
        navigationController?.navigationBar.layer.shadowOpacity = value
    }

}
