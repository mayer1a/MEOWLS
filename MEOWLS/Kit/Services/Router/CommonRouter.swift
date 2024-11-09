//
//  CommonRouter.swift
//  MEOWLS
//
//  Created by Artem Mayer on 17.09.2024.
//

import UIKit

public class CommonRouter: NSObject, CommonRouterProtocol {

    public weak var viewController: UIViewController?

    public func setCurrent(_ viewController: UIViewController) {
        self.viewController = viewController
    }

}
