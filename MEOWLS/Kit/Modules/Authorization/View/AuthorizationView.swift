//
//  AuthorizationView.swift
//  MEOWLS
//
//  Created Artem Mayer on 27.10.2024.
//

import SwiftUI

struct AuthorizationView<VM: AuthorizationViewModelProtocol>: View {
    
    @ObservedObject var viewModel: VM
    @State private var showRegionSelection: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                headerView
                phoneLabeledTextField
                passwordLabeledTextField

                VStack(spacing: 8) {
                    messageView
                        .fixedSize(horizontal: false, vertical: true)

                    continueButton
                    signUpButton
                }

                agreementText
                skipButton
            }
            .padding(.top, isPageSheet ? 40 : 0)
            .padding(.horizontal, 24)
            .showLoader(viewModel.isLoading)
            .onTapBackground {
                withAnimation {
                    viewModel.lostFocus()
                }
            }
            .ignoresSafeArea(viewModel.mode == .fullScreen ? .container : .all)
            .navigationBarHidden(true)
        }
        .onAppear(perform: viewModel.viewAppeared)
        .onDisappear(perform: viewModel.viewDisappeared)
    }

}

private extension AuthorizationView {

    var headerView: some View {
        VStack(spacing: 12) {
            Text("Common.Authorization.login")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Colors.Text.textPrimary.suiColor)

            if viewModel.showPromoTitle {
                Text("Common.Authorization.applyingPromoCode")
                    .multilineTextAlignment(.center)
                    .lineSpacing(viewModel.promoSubtitleLineHeight)
                    .font(.system(size: 16))
                    .foregroundStyle(Colors.Text.textPrimary.suiColor)
            }
        }
    }

    var phoneLabeledTextField: some View {
        DomainLabeledTextField(formatter: viewModel.formatter,
                               keyboardType: .numberPad,
                               textContentType: .telephoneNumber,
                               selectedRegion: $viewModel.selectedRegion,
                               regionCode: $viewModel.regionCode,
                               viewModel: $viewModel.phoneFieldState,
                               inputText: $viewModel.phone)
    }

    var passwordLabeledTextField: some View {
        DomainLabeledTextField(textContentType: .password,
                               viewModel: $viewModel.passwordFieldState,
                               inputText: $viewModel.password)
    }

    @ViewBuilder
    var messageView: some View {
        if let error = viewModel.error {
            switch error {
            case .error(let message):
                DomainMessage(label: message,
                              type: .error)

            case .info(let message):
                DomainMessage(label: message,
                              type: .info)

            }
        }
    }

    var continueButton: some View {
        Button {
            viewModel.continueButtonTap()
        } label: {
            Text("Common.continue")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Colors.Text.textWhite.suiColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Colors.Accent.accentPrimary.suiColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }

    var agreementText: some View {
        Text(viewModel.agreementText)
            .lineSpacing(viewModel.agreementLineHeight)
            .environment(\.openURL, OpenURLAction { url in
                viewModel.open(agreementURL: url)
                return .discarded
            })
    }

    @ViewBuilder
    var signUpButton: some View {
        #if Store

        Button {
            viewModel.signUp()
        } label: {
            Text("Common.Authorization.signUp")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Colors.Accent.accentPrimary.suiColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Colors.Accent.accentFaded.suiColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12.0))

        #endif
    }

    @ViewBuilder
    var skipButton: some View {
        if case .pageSheet(let closable) = viewModel.mode {
            if closable {
                Button {
                    viewModel.skipAuth()
                } label: {
                    Text("Common.Authorization.skip")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Colors.Accent.accentPrimary.suiColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }

            Spacer()
        }
    }

    var isPageSheet: Bool {
        switch viewModel.mode {
        case .fullScreen:
            return false

        case .pageSheet:
            return true

        }
    }

}
