//
// ProfileDataViewModel+AutocompleteModel.swift
// MEOWLS
//
// Created by Artem Mayer on 05.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//  

extension ProfileDataViewModel {

    func makeAutocompleteModel(for row: Model.Row) -> AutocompleteFieldModel.InputModel {
        let type = AutocompleteFieldModel.FieldType(rawValue: row.id)
        let fields = [Model.Row.surname.id: surname, Model.Row.name.id: name, Model.Row.patronymic.id: patronymic]
        let text = fields[row.id]
        let completion: ParameterClosure<String>? = { [weak self] suggest in
            switch row {
            case .surname:
                self?.surname = suggest

            case .name:
                self?.name = suggest
                if !suggest.isEmpty {
                    self?.updateErrorState(for: .name, hasError: false)
                }

            case .patronymic:
                self?.patronymic = suggest

            default:
                break

            }
        }

        let model = AutocompleteFieldModel.InputModel(inputText: text, fieldType: type) { [weak self] value, gender in
            completion?(value)

            if let gender {
                self?.gender = gender
            }
        }

        return model
    }

}
