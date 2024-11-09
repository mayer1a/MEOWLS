//
//  DomainLabeledTextFieldViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 29.10.2024.
//

extension DomainLabeledTextField {

    struct ViewModel: Equatable {

        var dataState: DataState
        var viewState: ViewState
        var isFocusable: Bool
        var isSecure: Bool

        struct DataState: Equatable {
            var label: String
            var errorText: String?
            var mask: String?

            init(label: String = "", errorText: String? = nil, mask: String? = nil) {
                self.label = label
                self.errorText = errorText
                self.mask = mask
            }
        }

        enum ViewState: Equatable {
            case `default`
            case focused
            case errorDefault
            case errorMask
            case errorFocused
            case disabled
        }

        init(dataState: DataState, viewState: ViewState = .default, isFocusable: Bool = true, isSecure: Bool = false) {
            self.dataState = dataState
            self.viewState = viewState
            self.isFocusable = isFocusable
            self.isSecure = isSecure
        }

    }

}
