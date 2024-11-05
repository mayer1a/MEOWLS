//
//  ProfileDataViewModelProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Foundation

protocol ProfileDataViewModelProtocol: ObservableObject {

    typealias Model = ProfileDataModel

    var isLoading: Bool { get }

    func dismiss()
    func lostFocus()

}
