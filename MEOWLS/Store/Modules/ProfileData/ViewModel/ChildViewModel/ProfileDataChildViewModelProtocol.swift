//
// ProfileDataChildViewModelProtocol.swift
// MEOWLS
//
// Created by Artem Mayer on 04.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Foundation

protocol ProfileDataChildViewModelProtocol: ObservableObject {

    typealias ResultHandler = (_ error: String?, _ phone: String?, _ token: String?) -> Void

    var surnamePublisher: Published<String>.Publisher { get }
    var namePublisher: Published<String>.Publisher { get }
    var patronymicPublisher: Published<String>.Publisher { get }
    var birthDatePublisher: Published<Date?>.Publisher { get }
    var genderPublisher: Published<UserCredential.Gender?>.Publisher { get }
    var phonePublisher: Published<String>.Publisher { get }
    var emailPublisher: Published<String>.Publisher { get }
    var canEditPhonePublisher: Published<Bool>.Publisher { get }
    var canEditBirthDatePublisher: Published<Bool>.Publisher { get }

    func fetch()
    func save(user: User.Update, completion: @escaping ResultHandler)

}
