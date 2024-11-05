//
// AutocompleteFieldViewModelProtocol.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import Foundation

protocol AutocompleteFieldViewModelProtocol: ObservableObject {

    typealias Model = AutocompleteFieldModel

    var query: String { get set }
    var textFieldState: DomainLabeledTextField.ViewModel { get set }
    var title: String { get }
    var hints: [Model.Hint] { get }
    var isLoading: Bool { get }

    func viewAppeared()
    func selected(hint: AttributedString)
    func complete()
    func lostFocus()

}
