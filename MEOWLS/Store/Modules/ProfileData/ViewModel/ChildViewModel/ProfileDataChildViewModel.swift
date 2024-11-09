//
// ProfileDataChildViewModel.swift
// MEOWLS
//
// Created by Artem Mayer on 04.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//  

import Foundation
import Combine

final class ProfileDataChildViewModel: ProfileDataChildViewModelProtocol {

    typealias ResultHandler = (_ error: String?, _ phone: String?, _ token: String?) -> Void

    var surnamePublisher: Published<String>.Publisher { $surname }
    var namePublisher: Published<String>.Publisher { $name }
    var patronymicPublisher: Published<String>.Publisher { $patronymic }
    var birthDatePublisher: Published<Date?>.Publisher { $birthDate }
    var genderPublisher: Published<UserCredential.Gender?>.Publisher { $gender }
    var phonePublisher: Published<String>.Publisher { $phone }
    var emailPublisher: Published<String>.Publisher { $email }
    var canEditPhonePublisher: Published<Bool>.Publisher { $canEditPhone }
    var canEditBirthDatePublisher: Published<Bool>.Publisher { $canEditBirthDate }

    @Published private var surname: String = ""
    @Published private var name: String = ""
    @Published private var patronymic: String = ""
    @Published private var birthDate: Date?
    @Published private var gender: UserCredential.Gender?
    @Published private var phone: String = ""
    @Published private var email: String = ""
    @Published private var canEditPhone: Bool = false
    @Published private var canEditBirthDate: Bool = false

    private var user: UserAccess & UserStore
    private let mode: ProfileDataModel.Mode
    private let apiService: ProfileDataApiServiceProtocol

    private var cancellables: Set<AnyCancellable> = []

    init(user: UserAccess & UserStore, apiService: ProfileDataApiServiceProtocol, mode: ProfileDataModel.Mode) {
        self.user = user
        self.apiService = apiService
        self.mode = mode

        canEditBirthDate = user.credentials?.birthday == nil || mode == .signUp
        canEditPhone = user.credentials?.phone?.isEmpty ?? true || mode == .signUp
    }

}

extension ProfileDataChildViewModel {

    var isUserAuthorized: Bool {
        user.isAuthorized
    }

    func fetch() {
        reloadCredentials()
    }

    func save(user: User.Update, completion: @escaping ResultHandler) {
        saveUser(user, completion: completion)
    }

}

private extension ProfileDataChildViewModel {

    func saveUser(_ user: User.Update, completion: @escaping ResultHandler) {
        if mode == .signUp {
            apiService.signUp(user: user) { [weak self] response in
                self?.responseHandler(response, completion: completion)
            }
        } else {
            // For an unauthorized user, data is stored locally
            guard isUserAuthorized else {
                self.user.credentials = packCredentials(user: user, storeAllFields: true)
                return
            }

            apiService.updateUserData(with: user) { [weak self] response in
                self?.responseHandler(response, completion: completion)
            }
        }
    }

    private func reloadCredentials(completion: VoidClosure? = nil) {
        guard user.isAuthorized else {
            return
        }

        apiService.reloadUser { [weak self] response in
            guard let self else {
                return
            }

            handle(credentials: response.data)
            completion?()
        }
    }

    private func responseHandler(_ response: APIResponse<UserCredential>, completion: @escaping ResultHandler) {
        guard let credentials = response.data else {
            completion(response.error, nil, nil)
            return
        }

        handle(credentials: credentials)
        completion(response.error, credentials.phone, credentials.authentication?.token)
    }

    func handle(credentials: UserCredential?) {
        guard let credentials else {
            return
        }

        if mode == .edit {
            user.credentials = credentials
        }
        update(credentials: credentials)
    }

}

private extension ProfileDataChildViewModel {

    func packCredentials(user: User.Update, storeAllFields: Bool) -> UserCredential {
        UserCredential(surname: user.surname,
                       name: user.name,
                       patronymic: user.patronymic,
                       birthday: (canEditBirthDate || storeAllFields) ? user.birthday?.toDate : nil,
                       gender: user.gender,
                       email: user.email,
                       phone: (canEditPhone || storeAllFields) ? user.phone : nil)
    }

    func update(credentials: UserCredential) {
        surname = credentials.surname ?? ""
        name = credentials.name ?? ""
        patronymic = credentials.patronymic ?? ""
        birthDate = credentials.birthday
        gender = credentials.gender
        email = credentials.email ?? ""
        phone = credentials.phone?.phoneFormatted() ?? ""
        canEditBirthDate = credentials.birthday == nil || mode == .signUp
        canEditPhone = phone.isEmpty || mode == .signUp
    }

}
