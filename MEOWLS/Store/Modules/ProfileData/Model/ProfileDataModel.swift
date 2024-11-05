//
//  ProfileDataModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Foundation

enum ProfileDataModel {}

extension ProfileDataModel {

    typealias SuccessCompletion = ((_ phone: String, _ token: String) -> Void)

    enum Mode {
        case signUp
        case edit
    }

    struct InputModel {
        let mode: Mode
        let phone: String?
        let completion: SuccessCompletion?
    }

    struct InitialModel {
        let inputModel: InputModel
        let router: ProfileDataRouterProtocol
        let apiService: ProfileDataApiServiceProtocol
    }

    enum Route {
        case warning(title: String, message: String)
        case networkError(model: NetworkErrorAlert)
    }

    enum Row: Swift.Identifiable, Equatable {

        case surname
        case name
        case patronymic
        case birthDate(tapAction: VoidClosure?)
        case gender(values: [UserCredential.Gender])
        case phone(tapAction: VoidClosure? = nil)
        case email
        case password
        case confirmPassword

        var id: String {
            switch self {
            case .surname: return "surname"
            case .name: return "name"
            case .patronymic: return "patronymic"
            case .birthDate: return "birthDate"
            case .gender: return "gender"
            case .phone: return "phone"
            case .email: return "email"
            case .password: return "password"
            case .confirmPassword: return "confirmPassword"
            }
        }

        static func == (lhs: ProfileDataModel.Row, rhs: ProfileDataModel.Row) -> Bool {
            switch (lhs, rhs) {
            case (.surname, .surname), (.name, .name), (.patronymic, .patronymic): return true
            case (.birthDate, .birthDate), (.gender, .gender), (.phone, .phone): return true
            case (.email, .email), (.password, .password), (.confirmPassword, .confirmPassword): return true
            default: return false
            }
        }

    }

}
