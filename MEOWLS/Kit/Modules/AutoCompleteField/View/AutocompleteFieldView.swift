//
// AutocompleteFieldView.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import SwiftUI

struct AutocompleteFieldView<VM: AutocompleteFieldViewModelProtocol>: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: VM
    @State private var listOpacity: CGFloat = 0.0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                DomainLabeledTextField(viewModel: $viewModel.textFieldState,
                                       inputText: $viewModel.query)
                .padding(.all, 16)

                list
                    .opacity(listOpacity)
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                backToolBarButton
                confirmToolBarButton
            }
            .onTapBackground(onTapBackground)
            .onAppear {
                viewModel.viewAppeared()
            }
            .showLoader(viewModel.isLoading, isBlocking: false)
        }
        .onChange(of: viewModel.hints.count) { newValue in
            withAnimation {
                listOpacity = 1.0
            }
        }
        .onChange(of: viewModel.query) { newValue in
            withAnimation {
                if newValue.isEmpty {
                    listOpacity = 0.0
                }
            }
        }
        .animation(.default, value: viewModel.textFieldState)
    }
    
}

private extension AutocompleteFieldView {

    var list: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.hints, id: \.id) { hint in
                    AutocompleteFieldSuggestionCell(hint: hint.text, tapAction: viewModel.selected)
                }
            }
            .onTapBackground(onTapBackground)
        }
    }

    var backToolBarButton: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(.navigationBack)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(Color(.accentPrimary))
                    .frame(width: 24, height: 24)
            }
        }
    }

    var confirmToolBarButton: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                viewModel.complete()
            } label: {
                Image(.check)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(Color(.accentPrimary))
                    .frame(width: 24, height: 24)
            }
        }
    }

    func onTapBackground() {
        withAnimation {
            viewModel.lostFocus()
        }
    }

}
