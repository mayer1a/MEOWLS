//
//  ProfileDataViewModelProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Foundation
import PhoneNumberKit

protocol ProfileDataViewModelProtocol: ObservableObject {

    typealias Model = ProfileDataModel

    var isLoading: Bool { get }
    var listItems: [Model.Row] { get }
    var focusedField: Model.Row? { get }
    var saveButtonTitle: String { get }
    var selectedRegion: String { get set }
    var regionCode: String { get set }
    var formatter: PartialFormatter { get }

    var surname: String { get set }
    var name: String { get set }
    var patronymic: String { get set }
    var birthDate: Date? { get set }
    var birthDateString: String { get set }
    var gender: UserCredential.Gender? { get set }
    var phone: String { get set }
    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }

    var surnameState: DomainLabeledTextField.ViewModel { get set }
    var nameState: DomainLabeledTextField.ViewModel { get set }
    var patronymicState: DomainLabeledTextField.ViewModel { get set }
    var birthDateState: DomainLabeledTextField.ViewModel { get set }
    var phoneState: DomainLabeledTextField.ViewModel { get set }
    var emailState: DomainLabeledTextField.ViewModel { get set }
    var passwordState: DomainLabeledTextField.ViewModel { get set }
    var confirmPasswordState: DomainLabeledTextField.ViewModel { get set }
    var birthDatePickerState: DatePickerControl.PickerState { get set }

    func setNextResponder(after: Model.Row)
    func saveCredentials()
    func showAutocomplete(for row: Model.Row)
    func dismiss()
    func lostFocus()

}
