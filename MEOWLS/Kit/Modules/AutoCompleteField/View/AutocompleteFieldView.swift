//
// AutocompleteFieldView.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import SwiftUI

struct AutocompleteFieldView<VM: AutocompleteFieldViewModelProtocol>: View {

    @ObservedObject var viewModel: VM

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
            }
            .navigationTitle(viewModel.title)
            .showLoader(viewModel.isLoading, isBlocking: false)
        }
    }
    
}

