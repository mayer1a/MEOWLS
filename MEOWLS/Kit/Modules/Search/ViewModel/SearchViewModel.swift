//
//  SearchViewModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.10.2024.
//

import Alamofire
import Combine

final class SearchViewModel: SearchViewModelProtocol {

    private typealias SearchBarState = DomainSearchBar.ViewModel.State

    @Published private var viewState: Model.ViewState = .initial(nil)
    @Published private var label: Model.Label? = nil

    var viewStatePublisher: Published<Model.ViewState>.Publisher { $viewState }
    var labelPublisher: Published<Model.Label?>.Publisher { $label }

    private let router: SearchRouterProtocol
    private let apiService: SearchApiServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    private let paginator: PaginatorProtocol
    private let dismissAction: VoidClosure?
    private var cancellables: Set<AnyCancellable> = []

    private var isLoadingMore: Bool = false
    private var searchRequest: DataRequest?
    private var productRequest: DataRequest?
    private var inputText: String?
    private var categories: [SearchSuggestion] = []
    private var productsIDs: [String] = []
    private var products: [Product] = []

    private var viewSize: CGSize = .zero

    init(with model: Model.InitialModel) {
        self.router = model.router
        self.apiService = model.apiService
        self.favoritesService = model.favoritesService
        self.paginator = model.paginator
        self.dismissAction = model.inputModel.completion
    }

}

extension SearchViewModel {

    func binding(input: Model.BindingInput) -> Model.BindingOutput {
        input.viewAction
            .sink { [weak self] action in
                self?.execute(action: action)
            }
            .store(in: &cancellables)

        return .init(label: labelPublisher.eraseToAnyPublisher(), viewState: viewStatePublisher.eraseToAnyPublisher())
    }

}

private extension SearchViewModel {

    func execute(action: Model.ViewAction) {
        switch action {
        case .viewDidLoad(let viewSize):
            self.viewSize = viewSize
            setupInitialSearchBarState()

        case .viewWillAppear:
            setupSearchingSearchBarState()

        case .triggerRefresh:
            refresh()

        case .dismiss:
            dismiss()

        case .loadMore:
            loadMoreProducts(productsIDs)

        }
    }

    func loadingState(_ status: Model.LoadingStatus) {
        viewState = .loading(status)
    }

    func fillingDataState() {
        loadingState(.stopLoading)

        let sections = createSections()
        viewState = .fillingDataState(.init(items: sections))
    }

    func setupInitialSearchBarState() {
        viewState = .initial(.init(placeHolder: Strings.Main.search, state: .initial(.init(tapHandler: nil))))
    }

    func setupSearchingSearchBarState() {
        let searchTextSubject = PassthroughSubject<String, Never>()
        searchTextSubject
            .map { [weak self] searchText in
                if searchText.isEmpty {
                    self?.inputText = nil
                    self?.viewState = .emptyText
                }

                return searchText
            }
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .filter { !$0.isEmpty }
            .sink(receiveValue: { [weak self] searchText in
                guard let self else {
                    return
                }

                inputText = searchText
                loadData(from: searchText)
            })
            .store(in: &cancellables)

        let searchingState = SearchBarState.Searching(textFieldSubject: searchTextSubject, cancelHandler: dismiss)
        viewState = .initial(.init(placeHolder: Strings.Main.search, state: .searching(searchingState)))
    }

    func showError(_ error: String?, isFirstPage: Bool, productsIDs: [String]? = nil) {
        let handler: VoidClosure = { [weak self] in
            guard let productsIDs else {
                self?.refresh()
                return
            }

            if isFirstPage {
                self?.loadProducts(productsIDs)
            } else {
                self?.isLoadingMore = false
                self?.loadMoreProducts(productsIDs)
            }
        }

        router.open(.networkError(model: .init(title: Strings.Common.FailedRequestView.title,
                                              message: error,
                                              repeatTitle: Strings.Common.FailedRequestView.button,
                                              repeatHandler: handler)))
    }

    func dismiss() {
        let toDismiss = router.viewController?.navigationController ?? router.viewController

        toDismiss?.dismiss { [weak self] in
            self?.dismissAction?()
        }
    }

}

private extension SearchViewModel {

    func createSections() -> [Model.Section] {
        let sectionsBuilder = SearchSectionsBuilder()
            .setCategories(categories)
            .setProducts(products)
            .setViewSize(viewSize)
            .setCategoryHandler({ [weak self] index in
                if let self, let existCategory = categories[safe: index]?.redirect.productsSet?.category {
                    router.open(.category(existCategory))
                }
            })
            .setHeaderTapHandler({ [weak self] in
                if let self, let inputText {
                    router.open(.products(productsIDs, inputText))
                }
            })
            .setFavoriteService(favoritesService)

        return sectionsBuilder.build()
    }

}

private extension SearchViewModel {

    func refresh() {
        if let inputText {
            loadData(from: inputText)
        }
    }

    func loadData(from query: String) {
        searchRequest?.cancel()
        productRequest?.cancel()

        loadingState(.startLoading)
        paginator.reset()

        searchRequest = apiService.search(query: query) { [weak self] response in
            guard let self else {
                return
            }

            guard let data = response.data, response.error == nil else {
                showError(response.error, isFirstPage: true)
                return
            }

            let (categories, productsIDs) = data.reduce(into: (categories: [SearchSuggestion](), ids: [String]())) {
                switch $1.redirect.redirectType {
                case .productsCollection:
                    $0.categories.append($1)

                case .object:
                    if let id = $1.redirect.objectID {
                        $0.ids.append(id)
                    }
                }
            }

            self.categories = categories
            loadProducts(productsIDs)
        }
    }

    func loadProducts(_ productsIDs: [String], with parameters: [String: Any]? = nil) {
        self.productsIDs = productsIDs

        if productsIDs.isEmpty {
            self.products = []
            self.productsIDs = []
            fillingDataState()

            return
        }

        productRequest?.cancel()

        if !isLoadingMore {
            loadingState(.startLoading)
        }

        productRequest = apiService.loadProducts(ids: productsIDs, with: parameters) { [weak self] response in
            guard let self else {
                return
            }

            guard let data = response.data, response.error == nil else {
                showError(response.error, isFirstPage: paginator.isFirstPage, productsIDs: productsIDs)
                return
            }

            paginator.pagination(with: data)

            if paginator.isFirstPage {
                products = data.results
            } else {
                products.append(contentsOf: data.results)
            }

            if !isLoadingMore {
                isLoadingMore = false
            }

            fillingDataState()
        }
    }

    func loadMoreProducts(_ productsIDs: [String]) {
        guard paginator.hasNextPage, !isLoadingMore else {
            return
        }

        isLoadingMore = true

        loadProducts(productsIDs, with: paginator.nextParameters)
    }

}
