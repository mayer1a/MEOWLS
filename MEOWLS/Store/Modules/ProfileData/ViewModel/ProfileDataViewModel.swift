//
//  ProfileDataViewModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 01.11.2024.
//

import Foundation
import Combine

final class ProfileDataViewModel: ProfileDataViewModelProtocol {

    @Published private(set) var isLoading: Bool
    private var completion: Model.SuccessCompletion?
    private let router: ProfileDataRouterProtocol
    private let apiService: ProfileDataApiServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(with model: Model.InitialModel) {
        self.completion = model.inputModel.completion
        self.router = model.router
        self.apiService = model.apiService
    }

}

// MARK: - ProfileDataViewModelProtocol

extension ProfileDataViewModel {

    func dismiss() {
    }

    func lostFocus() {
    }

}

// MARK: - UI

extension ProfileDataViewModel {

}

// MARK: - Route

private extension ProfileDataViewModel {

}

// MARK: - API

private extension ProfileDataViewModel {

}

// MARK: - Subscriptions

private extension ProfileDataViewModel {

}
