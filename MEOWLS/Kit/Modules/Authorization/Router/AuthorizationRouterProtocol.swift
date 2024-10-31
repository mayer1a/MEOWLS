//
//  AuthorizationRouterProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import UIKit

protocol AuthorizationRouterProtocol: CommonRouterProtocol {

    func open(_ route: AuthorizationModel.Route)
    func popViewController()

}
