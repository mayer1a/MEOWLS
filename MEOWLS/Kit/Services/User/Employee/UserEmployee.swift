//
//  UserEmployee.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.10.2024.
//

import Foundation

public protocol UserEmployee {

    typealias UserEmployeeError = String

    var credentials: EmployeeCredential? { get set }

    var id: String? { get }
    var username: String? { get }
    var surname: String? { get }
    var name: String? { get }
    var patronymic: String? { get }
    var avatar: String? { get }
    var email: String? { get }
    var phone: String? { get }
    var fullName: String { get }
    var position: String? { get }
    var roles: [EmployeeRole]? { get }

    func reloadCredentials() async throws

}

extension User: UserEmployee {

    public var credentials: EmployeeCredential? {
        set {
            settingsService[.userCredentials] = newValue
        }
        get {
            settingsService[.userCredentials]
        }
    }

    public var id: String? { credentials?.id }
    public var username: String? { credentials?.username }
    public var surname: String? { credentials?.surname }
    public var name: String? { credentials?.name }
    public var patronymic: String? { credentials?.patronymic }
    public var avatar: String? { credentials?.avatar }
    public var email: String? { credentials?.email }
    public var phone: String? { credentials?.phone }
    public var fullName: String {
        [surname, name, patronymic]
            .compactMap({ $0?.isEmpty ?? true ? nil : $0 })
            .joined(separator: " ")
    }
    public var position: String? { credentials?.position }
    public var roles: [EmployeeRole]? { credentials?.roles }

    public func reloadCredentials() async throws { }

}
