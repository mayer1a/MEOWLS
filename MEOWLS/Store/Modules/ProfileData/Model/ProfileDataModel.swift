//
//  ProfileDataModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Foundation

enum ProfileDataModel {}

extension ProfileDataModel {

    struct InputModel {
    }

    struct InitialModel {
        let inputModel: InputModel
        let router: ProfileDataRouterProtocol
        let apiService: ProfileDataApiServiceProtocol
    }

    enum Route {
    }

}
