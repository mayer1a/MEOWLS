//
//  CommonRouterProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 17.09.2024.
//

import UIKit

public protocol CommonRouterProtocol {

    var viewController: UIViewController? { get }

    func setCurrent(_ viewController: UIViewController)
    func close(animated: Bool, with completion: VoidClosure?)
    func push(_ vc: UIViewController)
    func present(_ vc: UIViewController)

}

public extension CommonRouterProtocol {

    func close(animated: Bool = true, with completion: VoidClosure? = nil) {
        guard let navVC = viewController?.navigationController else {
            viewController?.dismiss(animated: animated, completion: completion)
            return
        }

        if let rootvc = navVC.viewControllers.first, rootvc == viewController {
            navVC.dismiss(animated: animated, completion: completion)
        } else {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            navVC.popViewController(animated: animated)
            CATransaction.commit()
        }
    }

    func push(_ vc: UIViewController) {
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func present(_ vc: UIViewController) {
        viewController?.present(vc, animated: true)
    }

}
