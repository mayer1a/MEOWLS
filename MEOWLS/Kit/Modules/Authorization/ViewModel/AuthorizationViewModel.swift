//
//  AuthorizationViewModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import SwiftUI
import Combine
import PhoneNumberKit

final class AuthorizationViewModel: AuthorizationViewModelProtocol {

    @Published var isLoading: Bool = false
    @Published var phone: String = "" {
        didSet {
            isPhoneLastEdited = true
        }
    }
    @Published var password: String = "" {
        didSet {
            isPhoneLastEdited = false
        }
    }
    @Published var phoneFieldState: DomainLabeledTextField.ViewModel
    @Published var passwordFieldState: DomainLabeledTextField.ViewModel
    var regionCode: String
    var selectedRegion: String
    @Published private(set) var formatter: PartialFormatter
    @Published private(set) var agreementText: AttributedString = ""
    @Published private(set) var showPromoTitle: Bool
    @Published private(set) var error: Model.ErrorState?

    private(set) var mode: Model.Mode
    private(set) lazy var agreementLineHeight: CGFloat = {
        Constants.agreementTextLineHeight - agreementFont.lineHeight
    }()
    private(set) lazy var promoSubtitleLineHeight: CGFloat = {
        Constants.promoSubtitleLineHeight - UIFont.systemFont(ofSize: 16).lineHeight
    }()

    private var isPhoneLastEdited: Bool = true
    private var completion: ParameterClosure<Bool>?
    private let agreementFont: UIFont = UIFont.systemFont(ofSize: 14)
    private let phoneKit: PhoneNumberKit

    #if Store
        private let user: UserAuthorization
    #else
        private let user: UserEmployee & UserAccess
    #endif
    private let router: AuthorizationRouterProtocol
    private let apiService: AuthorizationApiServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    private var alreadyDisappearing: Bool = false

    init(with model: AuthorizationModel.InitialModel) {
        self.mode = model.inputModel.mode
        self.user = model.user
        self.router = model.router
        self.apiService = model.apiService
        self.completion = model.inputModel.completion
        self.phoneKit = model.phoneKit

        let defaultRegion = "RU"
        self.selectedRegion = defaultRegion
        self.regionCode = "+\(phoneKit.countryCode(for: defaultRegion)?.asString ?? "7")"
        self.formatter = PartialFormatter(defaultRegion: defaultRegion, withPrefix: false, maxDigits: 10)

        self.showPromoTitle = model.inputModel.forPromo
        let incorrectPhoneError = "Common.Authorization.incorrectNumberError"
        let incorrectPasswordFormatError = "Common.Authorization.incorrectPasswordFormatError"
        self.phoneFieldState = .init(dataState: .init(errorText: incorrectPhoneError))
        self.passwordFieldState = .init(dataState: .init(errorText: incorrectPasswordFormatError), isSecure: true)

        let numberExampleLabel = getFormattedExampleNumber()
        self.phoneFieldState.dataState.label = numberExampleLabel ?? ""
        self.passwordFieldState.dataState.label = "Common.Authorization.password"

        setupAgreementText()
    }

}

extension AuthorizationViewModel {

    func viewAppeared() {
        alreadyDisappearing = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.updateState(isFocus: true)
        }
    }

    func viewDisappeared() {
        if !alreadyDisappearing {
            completion?(true)
        }
    }

    func continueButtonTap() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            withAnimation {
                self.phoneFieldState.viewState = .default
                self.error = nil
            }

            do {
                isLoading = true
                let verifiedPhoneNumber = try phoneKit.verifyPhoneNumber(phone, for: selectedRegion)
                let password = try VerificationHelper.verifyPassword(password)
                signIn(with: verifiedPhoneNumber, password: password)
            } catch {
                isLoading = false

                withAnimation {
                    if error is PhoneNumberError {
                        self.phoneFieldState.viewState = .errorDefault
                    } else {
                        self.passwordFieldState.viewState = .errorDefault
                    }
                }
                print("Verification ended with an error")
            }
        }
    }

    func open(agreementURL: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else {
                return
            }

            alreadyDisappearing = true
            router.open(.agreement(url: agreementURL, mode: mode))
        }
    }

    func skipAuth() {
        alreadyDisappearing = true
        router.close(animated: true) { [weak self] in
            self?.completion?(true)
        }
    }

    func lostFocus() {
        updateState(isFocus: false)
    }

}

// MARK: - UI

private extension AuthorizationViewModel {

    func setupAgreementText() {
        agreementText = Self.getAgreementText()
        agreementText.font = agreementFont
    }

    func updateState(isFocus: Bool) {

        if isFocus {
            let lastSelected = isPhoneLastEdited ? phoneFieldState.viewState : passwordFieldState.viewState
            switch lastSelected {
            case .default:
                phoneFieldState.viewState = .focused

            case .errorDefault, .errorMask:
                phoneFieldState.viewState = .errorFocused

            default:
                break

            }
        } else {
            phoneFieldState.viewState = phoneFieldState.viewState == .errorFocused ? .errorDefault : .default
            passwordFieldState.viewState = passwordFieldState.viewState == .errorFocused ? .errorDefault : .default
        }
    }

    func setupErrorState(_ errorState: Model.ErrorState?) {
        withAnimation {
            self.error = errorState
        }
    }

    func getFormattedExampleNumber() -> String? {
        phoneKit.formattedExampleNumber(for: selectedRegion)
    }

}

// MARK: - API

private extension AuthorizationViewModel {

    func signIn(with phoneNumber: String, password: String) {
        isLoading = true
        
        let service: APIResourceService = mode == .fullScreen ? .pos : .store

        apiService.signIn(phone: phoneNumber, password: password, service: service) { [weak self] response in
            guard let self else {
                return
            }

            self.isLoading = false

            if let error = response.error {
                setupErrorState(.error(message: error))
            }

            if let data = response.data, let phone = data.phone, let token = data.authentication?.token {
                mode == .fullScreen ? (saveStaff(token: token)) : (saveCustomer(with: phone, token: token))
            }
        }
    }

    func saveCustomer(with phone: String, token: String) {
        let model = buildAuthHelperModel(phone: phone, token: token)

        #if Store
            AuthorizationHelper.storeLogin(from: model)
        #else
            AuthorizationHelper.posCustomerLogin(from: model)
        #endif
    }

    func saveStaff(token: String) {
        #if POS
            let model = buildAuthHelperModel(phone: "", token: token)
            AuthorizationHelper.posStaffLogin(from: model)
        #endif
    }

    private func buildAuthHelperModel(phone: String, token: String) -> AuthorizationHelper.CustomerLoginModel {
        let completion: ParameterClosure<String?> = { [weak self] error in
            guard let self else {
                return
            }

            isLoading = false

            let handler: VoidClosure = { [weak self] in
                self?.completion?(false)
            }

            #if Store

            if let error {
                let model = NetworkErrorAlert(message: error) { [weak self] in
                    DispatchQueue.main.async {
                        self?.saveCustomer(with: phone, token: token)
                    }
                } cancelHandler: { [weak self] in
                    self?.user.forceLogout()
                    self?.alreadyDisappearing = true
                    self?.router.close()
                }
                router.open(.networkError(model: model))

            } else {
                alreadyDisappearing = true
                router.close(with: handler)
            }

            #else

            alreadyDisappearing = true
            error.isNilOrEmpty ? (router.close(with: handler)) : (router.popViewController())

            #endif
        }

        return .init(phone: phone, token: token, user: user, completion: completion)
    }

}
