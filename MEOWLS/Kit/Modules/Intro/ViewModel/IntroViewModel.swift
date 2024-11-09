//
//  IntroViewModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.09.2024.
//

import Foundation
import Combine

final class IntroViewModel<ChildVM: IntroChildViewModelProtocol>: IntroViewModelProtocol {

    @Published private var isLoading: Bool = false

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }

    #if Store
    let isStore = true
    #else
    let isStore = false
    #endif

    private let router: IntroRouterProtocol
    private let childVM: ChildVM
    private var cancellables: Set<AnyCancellable> = []

    init(with model: IntroModel.InitialModel, childVM: ChildVM) {
        self.router = model.router
        self.childVM = childVM

        binding()
    }

    private func binding() {
        childVM.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
            }
            .store(in: &cancellables)

        childVM.showRoutePublisher
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] path in
                guard let self, let path else { return }


                router.open(path)
            }
            .store(in: &cancellables)
    }

    func viewDidLoad() {
        childVM.viewDidLoad(in: router.viewController)
    }

    func viewDidAppear() {
        childVM.viewDidAppear()
    }

}
