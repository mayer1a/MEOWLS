//
//  ProfileDataView.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import SwiftUI

struct ProfileDataView<VM: ProfileDataViewModelProtocol>: View {
    
    @ObservedObject var viewModel: VM

    var body: some View {
        NavigationView {
            ScrollView {
            }
            .showLoader(viewModel.isLoading)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile.Edit.title")
        }
    }

}

private extension ProfileDataView {

}
