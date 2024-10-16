//
//  RegionRouter.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.09.2024.
//

import UIKit

final class RegionRouter: CommonRouter, RegionRouterProtocol {

    func open(_ route: RegionModel.Route) {
        switch route {
        case .confirmationRegionDialog(let city, let handler):
            viewController?.show(confirmationOfRegion: city, yesHandler: handler)

        case .locationErrorDialog(let model):
            viewController?.show(warning: model.message, handler: model.handler)

        }
    }

}
