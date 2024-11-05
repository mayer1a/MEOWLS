//
//  ProfileDataView.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import SwiftUI

struct ProfileDataView<VM: ProfileDataViewModelProtocol>: View {
    
    @ObservedObject var viewModel: VM
    @State private var enableShadow: Bool = false
    @State private var offset: CGFloat = 0

    var body: some View {
        NavigationView {
            ScrollView {
                NavigationShadowVStack(alignment: .leading, enableShadow: $enableShadow) {
                    ForEach(viewModel.listItems, id: \.id) { row in
                        getView(for: row)
                            .id(row.id)
                            .padding(.top, 16)
                    }
                    saveButton
                }
                .padding([.horizontal, .bottom], 16)
                .onTapBackground(viewModel.lostFocus)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color(.clear)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 10, maxHeight: 20)
                    .ignoresSafeArea(.all)
            }
            .showLoader(viewModel.isLoading)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile.Edit.title")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
            }
            .navigationBarShadow(enable: $enableShadow)
        }
        .overlay {
            if viewModel.birthDatePickerState == .show {
                DatePickerControl(date: $viewModel.birthDate,
                                  dateState: $viewModel.birthDatePickerState,
                                  buttonTitle: "Common.add",
                                  isBirthday: true)
            }
        }
        .animation(.default, value: viewModel.birthDatePickerState)
    }

}

private extension ProfileDataView {

    var backButton: some View {
        Button {
            viewModel.dismiss()
        } label: {
            Image(.navigationBack)
                .renderingMode(.template)
                .foregroundColor(Color(.accentPrimary))
        }
    }

    var saveButton: some View {
        Button {
            viewModel.saveCredentials()
        } label: {
            Text(LocalizedStringKey(viewModel.saveButtonTitle))
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(.textWhite))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background {
                    Color(.accentPrimary)
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
        .padding(.vertical, 16)
    }

    @ViewBuilder
    func getView(for row: VM.Model.Row) -> some View {
        switch row {
        case .surname:
            DomainLabeledTextField(viewModel: $viewModel.surnameState,
                                   inputText: $viewModel.surname,
                                   tapAction: { viewModel.showAutocomplete(for: row) })

        case .name:
            DomainLabeledTextField(viewModel: $viewModel.nameState,
                                   inputText: $viewModel.name,
                                   tapAction: { viewModel.showAutocomplete(for: .name) })

        case .patronymic:
            DomainLabeledTextField(viewModel: $viewModel.patronymicState,
                                   inputText: $viewModel.patronymic,
                                   tapAction: { viewModel.showAutocomplete(for: .patronymic) })

        case .birthDate(let tapAction):
            DomainLabeledTextField(viewModel: $viewModel.birthDateState,
                                   inputText: $viewModel.birthDateString,
                                   tapAction: tapAction)

        case .gender(let values):
            GenderControl(genders: values,
                          hasError: .constant(false),
                          selectedGender: $viewModel.gender)

        case .phone(let tapAction):
            DomainLabeledTextField(formatter: viewModel.formatter,
                                   keyboardType: .numberPad,
                                   textContentType: .telephoneNumber,
                                   selectedRegion: $viewModel.selectedRegion,
                                   regionCode: $viewModel.regionCode,
                                   viewModel: $viewModel.phoneState,
                                   inputText: $viewModel.phone,
                                   tapAction: tapAction)

        case .email:
            DomainLabeledTextField(keyboardType: .emailAddress,
                                   textContentType: .emailAddress,
                                   viewModel: $viewModel.emailState,
                                   inputText: $viewModel.email)
            .submitLabel(.next)
            .onSubmit { viewModel.setNextResponder(after: .email) }

        case .password:
            DomainLabeledTextField(textContentType: .newPassword,
                                   viewModel: $viewModel.passwordState,
                                   inputText: $viewModel.password)
            .submitLabel(.next)
            .onSubmit { viewModel.setNextResponder(after: .password) }

        case .confirmPassword:
            DomainLabeledTextField(textContentType: .newPassword,
                                   viewModel: $viewModel.confirmPasswordState,
                                   inputText: $viewModel.confirmPassword)
            .submitLabel(.done)
            .onSubmit(viewModel.saveCredentials)

        }
    }

}
