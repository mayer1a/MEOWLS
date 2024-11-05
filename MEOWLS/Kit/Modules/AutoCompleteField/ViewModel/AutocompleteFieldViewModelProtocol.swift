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

    var isLoading: Bool { get }

}
