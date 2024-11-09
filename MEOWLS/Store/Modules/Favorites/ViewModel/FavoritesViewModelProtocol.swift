//
//  FavoritesViewModelProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 23.10.2024.
//

import Foundation

protocol FavoritesViewModelProtocol: ObservableObject {

    var isLoading: Bool { get }
    var isLoadingMore: Bool { get set }
    var items: [ProductListingCell.ViewModel] { get set }
    var cartProducts: [String] { get set }
    var isUserAuthorized: Bool { get }
    var isEmptyState: Bool { get }
    var emptyStateModel: (title: String, message: String) { get }

    func viewAppeared()
    func toggleFavoriteState(for product: Product)
    func addToCart(product: Product)
    func openItem(product: Product)
    func refresh()
    func actionButtonTap()
    func fetchMoreContent()

}
