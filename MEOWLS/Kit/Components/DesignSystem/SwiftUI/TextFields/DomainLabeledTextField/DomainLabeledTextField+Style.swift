//
//  DomainLabeledTextField+Style.swift
//  MEOWLS
//
//  Created by Artem Mayer on 30.10.2024.
//

import SwiftUI

extension DomainLabeledTextField {

    var backgroundColor: Color {
        Color(viewModel.viewState == .default ? .backgroundPrimary : .backgroundWhite)
    }

    var labelColor: Color {
        switch viewModel.viewState {
        case .default, .disabled, .focused:
            return Color(.textDisabled)

        case .errorDefault, .errorMask, .errorFocused:
            return Color(.badgeRedPrimary)

        }
    }

    var textColor: Color {
        switch viewModel.viewState {
        case .default, .focused, .errorFocused, .errorDefault:
            return Color(.textPrimary)

        case .disabled, .errorMask:
            return Color(inputText.isEmpty ? .textSecondary : .textPrimary)

        }
    }

    var strokeColor: Color {
        switch viewModel.viewState {
        case .default:
            return .clear

        case .disabled:
            return Color(.backgroundDisabled)

        case .focused:
            return Color(.textPrimary)

        case .errorDefault, .errorMask, .errorFocused:
            return Color(.badgeRedPrimary)

        }
    }

    var autocapitalization: TextInputAutocapitalization {
        keyboardType == .emailAddress ? .never : .sentences
    }

    var showPlaceholder: Bool {
        inputText.isEmpty && !showErrorMaskPlaceholder
    }

    var showErrorMaskPlaceholder: Bool {
        switch viewModel.viewState {
        case .errorMask, .errorFocused, .focused:
            return inputText.isEmpty && hasErrorMask

        default:
            return false

        }
    }

    var showSmallTopLabel: Bool {
        switch viewModel.viewState {
        case .errorMask, .errorFocused, .focused:
            return withRegionButton ? false : !showErrorMaskPlaceholder && !inputText.isEmpty

        default:
            return !inputText.isEmpty

        }
    }

    var showErrorMark: Bool {
        showErrorMessage && withRegionButton
    }

    var hasErrorMask: Bool {
        !viewModel.dataState.mask.isNilOrEmpty
    }

    var withRegionButton: Bool {
        regionCode?.wrappedValue.isEmpty == false && selectedRegion?.wrappedValue.isEmpty == false
    }

}
