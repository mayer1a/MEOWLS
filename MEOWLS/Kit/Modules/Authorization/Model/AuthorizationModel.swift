//
//  AuthorizationModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import Foundation
import PhoneNumberKit

public enum AuthorizationModel {}

extension AuthorizationModel {

    public typealias Mode = UIViewController.Mode

    public struct InputModel {
        public let mode: Mode
        public let forPromo: Bool
        public let completion: ParameterClosure<Bool>?

        public init(mode: Mode = .pageSheet(), forPromo: Bool = false, completion: ParameterClosure<Bool>? = nil) {
            self.mode = mode
            self.forPromo = forPromo
            self.completion = completion
        }
    }

    struct InitialModel {
        let inputModel: InputModel
        #if Store
            let user: UserAuthorization
        #else
            let user: UserEmployee & UserAccess
        #endif
        let router: AuthorizationRouterProtocol
        let apiService: AuthorizationApiServiceProtocol
        let phoneKit: PhoneNumberKit
    }

    enum Route {
        case signUp(phone: String?)
        case resetPassword(phone: String?)
        case agreement(url: URL, mode: Mode)
        case networkError(model: NetworkErrorAlert)
    }
    
    enum ErrorState {
        case info(message: String)
        case error(message: String)
    }

}

extension AuthorizationModel {

    enum Resource {

        enum Constants {
            static let agreementTextLineHeight: CGFloat = 20.0
            static let promoSubtitleLineHeight: CGFloat = 22.0
        }

    }

}
