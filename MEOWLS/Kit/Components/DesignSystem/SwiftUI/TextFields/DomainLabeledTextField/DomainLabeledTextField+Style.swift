//
//  DomainLabeledTextField+Style.swift
//  MEOWLS
//
//  Created by Artem Mayer on 30.10.2024.
//

import SwiftUI

extension DomainLabeledTextField {

    var backgroundColor: Color {
        let isDefault = viewModel.viewState == .default
        return isDefault ? Colors.Background.backgroundPrimary.suiColor : Colors.Background.backgroundWhite.suiColor
    }

    var labelColor: Color {
        switch viewModel.viewState {
        case .default, .disabled, .focused:
            return Colors.Text.textDisabled.suiColor

        case .errorDefault, .errorMask, .errorFocused:
            return Colors.Badge.badgeRedPrimary.suiColor

        }
    }

    var textColor: Color {
        switch viewModel.viewState {
        case .default, .focused, .errorFocused, .errorDefault:
            return Colors.Text.textPrimary.suiColor

        case .disabled, .errorMask:
            return inputText.isEmpty ? Colors.Text.textSecondary.suiColor : Colors.Text.textPrimary.suiColor

        }
    }

    var strokeColor: Color {
        switch viewModel.viewState {
        case .default:
            return .clear

        case .disabled:
            return Colors.Background.backgroundDisabled.suiColor

        case .focused:
            return Colors.Text.textPrimary.suiColor

        case .errorDefault, .errorMask, .errorFocused:
            return Colors.Badge.badgeRedPrimary.suiColor

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
