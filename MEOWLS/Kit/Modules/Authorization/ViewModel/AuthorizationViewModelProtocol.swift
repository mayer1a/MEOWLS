//
//  AuthorizationViewModelProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import PhoneNumberKit

protocol AuthorizationViewModelProtocol: ObservableObject {

    typealias Model = AuthorizationModel
    typealias Constants = Model.Resource.Constants

    var isLoading: Bool { get }
    var mode: Model.Mode { get }
    var agreementText: AttributedString { get }

    var phone: String { get set }
    var password: String { get set }
    var phoneFieldState: DomainLabeledTextField.ViewModel { get set }
    var passwordFieldState: DomainLabeledTextField.ViewModel { get set }
    var agreementLineHeight: CGFloat { get }
    var promoSubtitleLineHeight: CGFloat { get }
    var showPromoTitle: Bool { get }
    var error: Model.ErrorState? { get }
    var selectedRegion: String { get set }
    var regionCode: String { get set }
    var formatter: PartialFormatter { get }

    func viewAppeared()
    func viewDisappeared()
    func continueButtonTap()
    func open(agreementURL: URL)
    func skipAuth()
    func lostFocus()

}
