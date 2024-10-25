//
//  FavoritesViewModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 23.10.2024.
//

import UIKit
import Combine

final class FavoritesViewModel: FavoritesViewModelProtocol {

    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var items: [ProductListingCell.ViewModel] = [] {
        didSet {
            isEmptyState = items.isEmpty
        }
    }
    @Published var cartProducts: [String] = []
    @Published var isUserAuthorized: Bool = false
    @Published var isEmptyState: Bool = true
    @Published var emptyStateModel: (title: String, message: String) = ("", "")

    private var needRefresh: Bool = true
    private let router: FavoritesRouterProtocol
    private let apiService: FavoritesApiServiceProtocol
    private let user: UserAccess
    private let favoritesService: FavoritesServiceProtocol
    private let paginator: PaginatorProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(with model: FavoritesModel.InitialModel) {
        self.router = model.router
        self.apiService = model.apiService
        self.user = model.user
        self.favoritesService = model.favoritesService
        self.paginator = model.paginator
        self.isUserAuthorized = user.isAuthorized

        makeItemsSubscription()
    }

}

extension FavoritesViewModel {

    func viewAppeared() {
        refresh()
    }

    func toggleFavoriteState(for product: Product) {
        isLoading = true
        favoritesService.toggle(item: product) { [weak self] _ in
            self?.isLoading = false
        }
    }

    func addToCart(product: Product) {
        router.open(.propertiesSelectionSheet(product) { [weak self] in
            self?.requestCart()
        })
    }

    func openItem(product: Product) {
        needRefresh = false
        router.open(.product(product))
    }

    func refresh() {
        requestCart()

        guard needRefresh else {
            needRefresh = true
            return
        }

        loadFavorites()
    }

    func actionButtonTap() {
        isUserAuthorized ? router.open(.catalogue) : router.open(.auth)
    }

    func fetchMoreContent() {
        loadMore()
    }

}

private extension FavoritesViewModel {

    func loadFavorites() {
        paginator.reset()

        if user.isAuthorized {
            isLoading = true
            authorizedFavorites()
        } else if !isLoading {
            isLoading = true
            localFavorites()
        }
    }

    func loadMore() {
        if user.isAuthorized, paginator.hasNextPage {
            authorizedFavorites()
        }
    }

    func showError(_ error: String?, isFirstPage: Bool) {
        let handler: VoidClosure = { [weak self] in
            if isFirstPage {
                self?.refresh()
            } else {
                self?.fetchMoreContent()
            }
        }
        router.open(.networkError(.init(message: error, repeatHandler: handler)))
    }

    func setShadowState(_ isEmptyState: Bool, _ isUserAuthorized: Bool) {
        if !isEmptyState, !isUserAuthorized {
            router.viewController?.setShadowOpacity(with: 0)
        } else {
            router.viewController?.setShadowOpacity(with: 1)
        }
    }

    func setEmptyStateModel(_ isUserAuthorized: Bool) {
        let title: String
        let description: String

        if isUserAuthorized {
            title = Strings.Favorites.authorizedMessage
            description = Strings.Favorites.authorizedDescription
        } else {
            title = Strings.Favorites.unauthorizedMessage
            description = Strings.Favorites.unauthorizedDescription
        }
        emptyStateModel = (title, description)
    }

}

private extension FavoritesViewModel {

    func authorizedFavorites() {
        guard !isLoadingMore else {
            return
        }

        isLoadingMore = true

        apiService.loadFavorites(with: paginator.nextParameters) { [weak self] response in
            guard let self else {
                return
            }

            isLoadingMore = false
            handle(response: response)
        }
    }

    func localFavorites() {
        let ids = favoritesService.ids.prefix(20).map({ $0.identifier })

        apiService.loadProducts(ids: ids, with: paginator.nextParameters) { [weak self] response in
            guard let self else {
                return
            }

            handle(response: response)
        }
    }

    func requestCart() {
    }

    func handle(response: APIResponse<PaginationResponse<Product>>) {
        guard let data = response.data, response.error == nil else {
            showError(response.error, isFirstPage: paginator.isFirstPage)
            return
        }

        if paginator.isFirstPage {
            if !data.results.isEqual(items) {
                items = FavoritesCellFactory.buildCellModels(from: data.results)
            }
        } else {
            items.append(contentsOf: FavoritesCellFactory.buildCellModels(from: data.results))

        }
        isLoading = false
        paginator.pagination(with: data)
    }

}

private extension FavoritesViewModel {

    func makeItemsSubscription() {
        Publishers.CombineLatest($isEmptyState, $isUserAuthorized)
            .receive(on: DispatchQueue.main)
            .removeDuplicates(by: { $0.0 == $1.0 && $0.1 == $1.1 })
            .sink { [weak self] isEmptyState, isUserAuthorized in
                self?.setShadowState(isEmptyState, isUserAuthorized)
                self?.setEmptyStateModel(isUserAuthorized)
            }
            .store(in: &cancellables)
    }

}

