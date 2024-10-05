//
//  UserStore.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Foundation

public protocol UserStore {

    var credentials: UserCredential? { get set }
    var surname: String? { get }
    var name: String? { get }
    var patronymic: String? { get }
    var birthday: Date? { get }
    var gender: UserCredential.Gender? { get }
    var email: String? { get }
    var phone: String? { get }
    var fio: String { get }
    var favoriteProducts: [String]? { get }

}

extension User: UserStore {

    public var credentials: UserCredential? {
        set { settingsService[.userCredentials] = newValue }
        get { return settingsService[.userCredentials] }
    }

    public var surname: String? { credentials?.surname }
    public var name: String? { credentials?.name }
    public var patronymic: String? { credentials?.patronymic }
    public var birthday: Date? { credentials?.birthday }
    public var gender: UserCredential.Gender? { credentials?.gender }
    public var email: String? { credentials?.email }
    public var phone: String? { credentials?.phone }
    public var fio: String {
        [surname, name, patronymic]
            .compactMap({ $0?.isEmpty ?? true ? nil : $0 })
            .joined(separator: " ")
    }
    public var favoriteProducts: [String]? { credentials?.favoriteProducts }

}

