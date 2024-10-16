//
//  IntroRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.09.2024.
//

import UIKit

final class IntroRouter: CommonRouter, IntroRouterProtocol {

    func open(_ route: IntroModel.Route) {
        switch route {
        case .mainFlow:
            Router.showMainController()

        }
    }

}
