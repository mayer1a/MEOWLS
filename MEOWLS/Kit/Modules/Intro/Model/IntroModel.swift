//
//  IntroModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.09.2024.
//

import Foundation

public enum IntroModel {}

public extension IntroModel {

    struct InputModel {}

    struct InitialModel {
        let inputModel: InputModel
        let router: IntroRouterProtocol
    }

    enum Route {
        case mainFlow
        case underConstruction
    }

}
