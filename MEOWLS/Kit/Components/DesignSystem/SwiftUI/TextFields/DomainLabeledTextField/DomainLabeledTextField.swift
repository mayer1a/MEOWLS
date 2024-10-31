//
//  DomainLabeledTextField.swift
//  MEOWLS
//
//  Created by Artem Mayer on 29.10.2024.
//

import SwiftUI
import Combine
import PhoneNumberKit

struct DomainLabeledTextField: View {

    weak var formatter: PartialFormatter? = nil

    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var selectedRegion: Binding<String>? = nil
    var regionCode: Binding<String>? = nil

    @Binding var viewModel: ViewModel
    @Binding var inputText: String
    @State var tapAction: VoidClosure? = nil

    @State private var showPassword: Bool = false
    @FocusState private var textFieldFocused: Bool
    @FocusState private var secureTextFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            customTextField
            if showErrorMessage {
                errorMessageText
            }
        }
        .animation(.default, value: viewModel.viewState)
    }

}

private extension DomainLabeledTextField {

    var customTextField: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(strokeColor, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(backgroundColor))

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    if showSmallTopLabel, !withRegionButton {
                        topLabelView
                    }

                    HStack(alignment: .center, spacing: 8) {
                        regionSelectionButton
                        inpuTextField
                    }
                }

                if showClearButton {
                    clearButton
                }
                if viewModel.isSecure {
                    showPasswordButton
                }
                if showErrorMark {
                    errorMark
                }
            }
            .padding(.all, 8)
        }
        .frame(height: 54)
        .disabled(viewModel.viewState == .disabled)
        .onAppear {
            showPassword = !viewModel.isSecure
        }
        .onTapGesture {
            viewModel.viewState = newFocusState
        }
        .onChange(of: viewModel.viewState) { newState in
            updateFocusState(with: newState)
        }
        .onChange(of: textFieldFocused || secureTextFieldFocused) { focused in
            resetFocusIfNeeded(with: focused)
        }
    }

    var inpuTextField: some View {
        Group {
            SecureField("", text: $inputText)
                .focused($secureTextFieldFocused)
                .textInputAutocapitalization(.never)
                .opacity(showPassword ? 0 : 1)

            TextField("", text: $inputText)
                .focused($textFieldFocused)
                .textInputAutocapitalization(autocapitalization)
                .opacity(showPassword ? 1 : 0)
        }
        .font(.system(size: 16, weight: .medium))
        .tint(Color(.accentPrimary))
        .foregroundStyle(textColor)
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .autocorrectionDisabled(keyboardType == .emailAddress || keyboardType == .numberPad)
        .phoneFormattedText($inputText, formatter: formatter)
        .placeholder(when: showPlaceholder) {
            Text(LocalizedStringKey(viewModel.dataState.label))
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(labelColor)
        }
        .placeholder(when: showErrorMaskPlaceholder) {
            Text(LocalizedStringKey(viewModel.dataState.mask ?? ""))
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(.textSecondary))
        }
        .disabled(disabledTextField)
    }

    // MARK: - Optional

    var showPasswordButton: some View {
        Button {
            showPassword.toggle()
            toggleVisibility()
        } label: {
            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                .renderingMode(.template)
                .foregroundStyle(Color(.iconTertiary))
                .frame(width: 20, height: 20)
                .padding([.vertical, .leading], 8)
        }
    }

}

private extension DomainLabeledTextField {

    func toggleVisibility() {
        if showPassword {
            textFieldFocused = true
        } else {
            secureTextFieldFocused = false
        }
    }

    func updateFocusState(with newState: ViewModel.ViewState) {
        switch newState {
        case .default, .disabled, .errorDefault, .errorMask:
            textFieldFocused = false
            secureTextFieldFocused = false

        case .errorFocused, .focused:
            textFieldFocused = showPassword
            secureTextFieldFocused = !showPassword

        }
    }

    func resetFocusIfNeeded(with focused: Bool) {
        guard !focused else {
            return
        }

        var newState: ViewModel.ViewState?

        switch viewModel.viewState {
        case .focused:
            newState = .default

        case .errorMask, .errorFocused:
            newState = .errorDefault

        default:
            return

        }

        if let newState, newState != viewModel.viewState {
            viewModel.viewState = newState
        }
    }

}
