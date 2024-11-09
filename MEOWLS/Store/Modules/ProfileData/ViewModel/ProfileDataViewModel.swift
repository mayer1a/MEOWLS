//
//  ProfileDataViewModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Foundation
import Combine
import PhoneNumberKit

final class ProfileDataViewModel<ChildViewModel: ProfileDataChildViewModelProtocol>: ProfileDataViewModelProtocol {

    var selectedRegion: String
    var regionCode: String

    @Published var surname: String = ""
    @Published var name: String = ""
    @Published var patronymic: String = ""
    @Published var birthDate: Date?
    @Published var birthDateString: String = ""
    @Published var gender: UserCredential.Gender?
    @Published var phone: String
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var canEditBirthDate: Bool
    @Published var canEditPhone: Bool

    @Published var surnameState: DomainLabeledTextField.ViewModel
    @Published var nameState: DomainLabeledTextField.ViewModel
    @Published var patronymicState: DomainLabeledTextField.ViewModel
    @Published var birthDateState: DomainLabeledTextField.ViewModel
    @Published var phoneState: DomainLabeledTextField.ViewModel
    @Published var emailState: DomainLabeledTextField.ViewModel
    @Published var passwordState: DomainLabeledTextField.ViewModel
    @Published var confirmPasswordState: DomainLabeledTextField.ViewModel
    @Published var birthDatePickerState: DatePickerControl.PickerState = .dateUnpicked

    @Published private(set) var isLoading: Bool
    @Published private(set) var focusedField: Model.Row?
    @Published private(set) var saveButtonTitle: String
    @Published private(set) var formatter: PartialFormatter
    @Published private(set) var listItems: [Model.Row] = []
    @Published private var childViewModel: ChildViewModel

    private let userBuilder: UserBuilder
    private let mode: Model.Mode
    private let phoneKit: PhoneNumberKit
    private var completion: Model.SuccessCompletion?
    private let router: ProfileDataRouterProtocol
    private let apiService: ProfileDataApiServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(with model: Model.InitialModel, childViewModel: ChildViewModel) {
        self.userBuilder = UserBuilder(isFullValidation: model.inputModel.mode == .signUp)
        self.mode = model.inputModel.mode
        self.childViewModel = childViewModel

        self.phoneKit = model.phoneKit
        self.completion = model.inputModel.completion
        self.router = model.router
        self.apiService = model.apiService

        self.isLoading = model.inputModel.mode == .edit
        self.saveButtonTitle = mode == .signUp ? "Common.Authorization.signUp" : "Common.save"
        let defaultRegion = "RU"
        self.selectedRegion = defaultRegion
        self.regionCode = "+\(phoneKit.countryCode(for: defaultRegion)?.asString ?? "7")"
        self.formatter = PartialFormatter(defaultRegion: defaultRegion, withPrefix: false, maxDigits: 10)
        self.surnameState = TextFieldStateFactory.makeSurname()
        self.nameState = TextFieldStateFactory.makeName()
        self.patronymicState = TextFieldStateFactory.makePatronymic()
        self.canEditBirthDate = model.inputModel.mode == .edit
        self.canEditPhone = model.inputModel.mode == .edit

        self.phone = model.inputModel.phone ?? ""
        self.emailState = TextFieldStateFactory.makeEmail()
        self.passwordState = TextFieldStateFactory.makePassword()
        self.confirmPasswordState = TextFieldStateFactory.makeConfirmPassword()
        let exampleNumber = phoneKit.formattedExampleNumber(for: selectedRegion)
        self.phoneState = TextFieldStateFactory.makePhone(exampleNumber: exampleNumber)
        self.birthDateState = .init(dataState: .init())
        self.birthDateState = TextFieldStateFactory.makeBirthDate(canEdit: canEditBirthDate)

        buildRows()

        bindChildViewModel()
        makeBirthDateSubscription()
        makeBirthDateObserverSubscription()
        makePasswordSubscription()
        makeCanEditSubscription()
    }

}

// MARK: - ProfileDataViewModelProtocol

extension ProfileDataViewModel {

    func setNextResponder(after currentRow: Model.Row) {
        switch currentRow {
        case .phone:
            emailState.viewState = .focused
            focusedField = .email

        case .email:
            passwordState.viewState = .focused
            focusedField = .password

        case .password:
            confirmPasswordState.viewState = .focused
            focusedField = .confirmPassword

        default:
            break

        }
    }

    func saveCredentials() {
        lostFocus()
        updateUser()
    }

    func showAutocomplete(for row: Model.Row) {
        openAutocomplete(for: row)
    }

    func dismiss() {
        router.close(animated: true, with: nil)
    }

    func lostFocus() {
        updateState()
    }

}

// MARK: - UI

extension ProfileDataViewModel {

    private func buildRows(isEmptyPassword: Bool = true) {
        var rows: [Model.Row] = [
            .surname, .name, .patronymic, .birthDate(tapAction: showPicker),
            .gender(values: UserCredential.Gender.allCases),
            .phone(tapAction: showPhoneAlert), .email, .password
        ]

        if !isEmptyPassword {
            rows.append(.confirmPassword)
        }

        listItems = rows
    }

    private func updateState() {
        let phoneIsError = phoneState.viewState == .errorFocused
        phoneState.viewState = phoneIsError ? .errorDefault : canEditPhone ? .default : .disabled
        emailState.viewState = emailState.viewState == .errorFocused ? .errorDefault : .default
        passwordState.viewState = passwordState.viewState == .errorFocused ? .errorDefault : .default
        confirmPasswordState.viewState = confirmPasswordState.viewState == .errorFocused ? .errorDefault : .default
        focusedField = nil
    }

}

// MARK: - Route

private extension ProfileDataViewModel {

    func openAutocomplete(for row: Model.Row) {
        let model = makeAutocompleteModel(for: row)
        router.open(.autocomplete(model: model))
    }

    func showPicker() {
        lostFocus()

        if canEditBirthDate {
            birthDatePickerState = .show
        } else {
            router.open(.warning(title: Strings.Profile.Edit.birthday, message: Strings.Profile.Edit.birthdayImmutable))
        }
    }

    func showPhoneAlert() {
        lostFocus()

        if !canEditPhone {
            router.open(.warning(title: Strings.Profile.Edit.phone, message: Strings.Profile.Edit.phoneImmutable))
        }
    }

}

// MARK: - API

private extension ProfileDataViewModel {

    func updateUser() {
        isLoading = true

        guard validate(userBuilder: userBuilder, phoneKit: phoneKit), let user = try? userBuilder.build() else {
            isLoading = false
            return
        }

        childViewModel.save(user: user) { [weak self] error, phone, token in
            guard let self else {
                return
            }

            isLoading = false

            if let phone, let token {
                router.close(animated: true) { [weak self] in
                    self?.completion?(phone, token)
                }
            } else {
                router.viewController?.showNetworkError(with: .init(message: error, repeatHandler: { [weak self] in
                    self?.updateUser()
                }))
            }
        }
    }

}

// MARK: - Subscriptions

private extension ProfileDataViewModel {

    func bindChildViewModel() {
        childViewModel.surnamePublisher.assign(to: &$surname)
        childViewModel.namePublisher.assign(to: &$name)
        childViewModel.patronymicPublisher.assign(to: &$patronymic)
        childViewModel.birthDatePublisher.assign(to: &$birthDate)
        childViewModel.genderPublisher.assign(to: &$gender)
        childViewModel.phonePublisher.assign(to: &$phone)
        childViewModel.emailPublisher.assign(to: &$email)
        childViewModel.canEditBirthDatePublisher.assign(to: &$canEditBirthDate)
        childViewModel.canEditPhonePublisher.assign(to: &$canEditPhone)
    }

    func makeBirthDateSubscription() {
        $birthDate
            .removeDuplicates()
            .sink { [weak self] newDate in
                self?.birthDateString = newDate?.birthDate ?? ""
            }
            .store(in: &cancellables)
    }

    func makeBirthDateObserverSubscription() {
        $birthDateString
            .filter({ $0.isEmpty })
            .sink { [weak self] _ in
                self?.birthDate = nil
            }
            .store(in: &cancellables)
    }

    func makePasswordSubscription() {
        $password
            .map({ $0.isEmpty })
            .removeDuplicates()
            .sink { [weak self] isEmpty in
                if isEmpty {
                    self?.confirmPassword = ""
                }
                self?.buildRows(isEmptyPassword: isEmpty)
            }
            .store(in: &cancellables)
    }

    func makeCanEditSubscription() {
        Publishers.CombineLatest($canEditPhone, $canEditBirthDate)
            .receive(on: DispatchQueue.main)
            .removeDuplicates(by: { $0.0 == $1.0 && $0.1 == $1.1 })
            .sink { [weak self] canEditPhone, canEditBirthDate in
                self?.phoneState.isFocusable = canEditPhone
                self?.phoneState.viewState = canEditPhone ? .default : .disabled
                self?.birthDateState.viewState = canEditBirthDate ? .default : .disabled
            }
            .store(in: &cancellables)
    }

}
