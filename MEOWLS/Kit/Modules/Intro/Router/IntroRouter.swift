//
//  IntroRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.09.2024.
//

import UIKit
import Factory

final class IntroRouter: CommonRouter, IntroRouterProtocol {

    func open(_ route: IntroModel.Route) {
        switch route {
        case .mainFlow:
            Router.showMainController()

        case .underConstruction:
            let vc = Container.shared.underDevelopmentViewBuilder.resolve("")
            vc.modalPresentationStyle = .fullScreen
            vc.isModalInPresentation = false
            viewController?.present(vc, animated: false)

        }
    }

}
