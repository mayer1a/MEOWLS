//
//  SearchModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.10.2024.
//

import Combine
import UIKit

enum SearchModel {}

extension SearchModel {

    struct InputModel {

        let completion: VoidClosure?

        init(completion: VoidClosure? = nil) {
            self.completion = completion
        }

    }

    struct InitialModel {
        let inputModel: InputModel
        let router: SearchRouterProtocol
        let apiService: SearchApiServiceProtocol
        let favoritesService: FavoritesServiceProtocol
        let paginator: PaginatorProtocol
    }

    struct CollectionHeaderModel {
        let viewModel: DomainBoldWithButtonCollectionHeader.ViewModel
        let hasProducts: Bool
        let hasCategories: Bool
        let minimumLineSpacing: CGFloat
        let insetForProductSection: UIEdgeInsets
    }

    typealias Section = ItemsDataSource<Row>.Section<Row>

    enum Row: Item {
        case categories(SearchTagsCollectionCell.ViewModel)
        case product(ProductCell.ViewModel)
    }

    enum Route {
        case category(Category)
        case product(Product)
        case products(_ ids: [String], _ title: String)
        case networkError(with: NetworkError)
    }

    struct NetworkError {
        let message: String?
        let repeatHandler: VoidClosure?
    }

}

extension SearchModel {

    struct BindingInput {
        let viewAction: PassthroughSubject<ViewAction, Never>
    }

    struct BindingOutput {
        let label: AnyPublisher<Label?, Never>
        let viewState: AnyPublisher<ViewState, Never>
    }

    enum Label {}

    enum ViewState {
        case initial(DomainSearchBar.ViewModel?)
        case loading(LoadingStatus)
        case fillingDataState(FillingDataState)
        case emptyText

        struct FillingDataState {
            let items: [Section]
        }
    }

    enum ViewAction {
        case viewDidLoad(_ size: CGSize)
        case viewWillAppear
        case loadMore
        case triggerRefresh
        case dismiss
    }

    enum LoadingStatus {
        case startLoading, stopLoading
    }

}
