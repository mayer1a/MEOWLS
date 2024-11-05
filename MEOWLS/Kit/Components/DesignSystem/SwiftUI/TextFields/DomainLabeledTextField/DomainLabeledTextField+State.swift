//
//  DomainLabeledTextField+State.swift
//  MEOWLS
//
//  Created by Artem Mayer on 30.10.2024.
//

import SwiftUI

extension DomainLabeledTextField {

    var showErrorMessage: Bool {
        switch viewModel.viewState {
        case .errorDefault, .errorMask, .errorFocused:
            return true

        default:
            return false

        }
    }

    var showClearButton: Bool {
        switch viewModel.viewState {
        case .default, .errorDefault, .errorFocused, .focused:
            return !inputText.isEmpty

        default:
            return false

        }
    }

    var disabledTextField: Bool {
        viewModel.viewState != .focused && viewModel.viewState != .errorFocused
    }

    var newFocusState: ViewModel.ViewState {
        tapAction?()

        guard viewModel.isFocusable else {
            return viewModel.viewState
        }

        switch viewModel.viewState {
        case .default:
            return .focused

        case .disabled:
            return .disabled

        case .errorDefault:
            return .focused

        case .errorMask:
            return .focused

        case .errorFocused:
            return .errorFocused

        case .focused:
            return .focused

        }
    }

}
