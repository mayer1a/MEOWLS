//
//  FavoritesView.swift
//  MEOWLS
//
//  Created Artem Mayer on 23.10.2024.
//

import SwiftUI
import Combine

struct FavoritesView<VM: FavoritesViewModelProtocol>: View {

    @ObservedObject var viewModel: VM
    @State private var enableShadow: Bool = false
    @State private var unauthorizedTopViewHeight: CGFloat = 0
    @State private var isLoadingMore: Bool = false

    private var shadow: Binding<Bool> {
        !viewModel.isUserAuthorized && !viewModel.isEmptyState ? .constant(false) : $enableShadow
    }

    var body: some View {
        goodsListingView
            .navigationTitle("Favorites.title")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarShadow(enable: $enableShadow)
            .showLoader(viewModel.isLoading,
                        isBlocking: false)
            .onAppear {
                viewModel.viewAppeared()
            }
            .animation(.default, value: viewModel.isEmptyState)
    }

}

private extension FavoritesView {

    @ViewBuilder
    var goodsListingView: some View {
        if viewModel.isEmptyState {
            emptyStateView
        } else {
            VStack {
                if !viewModel.isUserAuthorized {
                    unauthorizedTopView
                        .viewShadow(enable: .constant(true))
                        .zIndex(1)

                }

                ProductsListingView(isShortMode: .constant(false),
                                    items: $viewModel.items,
                                    cartProducts: $viewModel.cartProducts,
                                    enableShadow: shadow,
                                    isLoadingMore: $isLoadingMore,
                                    canTransparentCell: true,
                                    ratioMultiplier: 1,
                                    favoriteHandler: { viewModel.toggleFavoriteState(for: $0) },
                                    cartAction: handleCartAction,
                                    fetchMoreContent: { viewModel.fetchMoreContent() },
                                    onTapHandler: { viewModel.openItem(product: $0) })
                .refreshable {
                    DispatchQueue.main.async {
                        viewModel.refresh()
                    }
                }
                .onChange(of: viewModel.isLoadingMore) { newValue in
                    isLoadingMore = !viewModel.isLoading && newValue
                }
            }
        }
    }

    var emptyStateView: some View {
        VStack(alignment: .center, spacing: 24) {
            VStack(spacing: 8) {
                Text(viewModel.emptyStateModel.title)
                    .font(UIFont.boldSystemFont(ofSize: 24).asFont)
                    .foregroundStyle(Colors.Text.textPrimary.suiColor)
                Text(viewModel.emptyStateModel.message)
                    .font(UIFont.systemFont(ofSize: 16).asFont)
                    .foregroundStyle(Colors.Text.textSecondary.suiColor)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)

            actionButton
        }
        .padding(.horizontal, 16)
        .onAppear {
            withAnimation {
                enableShadow = true
            }
        }
        .onDisappear {
            withAnimation {
                enableShadow = false
            }
        }
    }

    var unauthorizedTopView: some View {
        VStack(spacing: 16) {
            DomainMessage(label: "Favorites.unuthorizedTopMessage",
                          type: .attention)

            actionButton
        }
        .padding([.horizontal, .top], 16)
    }

    var actionButton: some View {
        Button {
            viewModel.actionButtonTap()
        } label: {
            Text(actionButtonTitle)
                .font(UIFont.systemFont(ofSize: 16, weight: .semibold).asFont)
                .foregroundStyle(Colors.Text.textWhite.suiColor)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Colors.Accent.accentPrimary.suiColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }

    var actionButtonTitle: LocalizedStringKey {
        viewModel.isUserAuthorized ? "Favorites.authorizedButton" : "Common.Authorization.login"
    }

}

private extension FavoritesView {

    func handleCartAction(for product: Product) {
        if product.newPrice()?.asPrice == nil {
            viewModel.openItem(product: product)
        } else {
            viewModel.addToCart(product: product)
        }
    }

}

// MARK: - Previews

#if DEBUG

private final class MockViewModel: FavoritesViewModelProtocol {

    var isLoading: Bool = false
    var isLoadingMore: Bool = false
    var items: [ProductListingCell.ViewModel] = []
    var cartProducts: [String] = []
    var isUserAuthorized: Bool = false
    var isEmptyState: Bool = false
    var emptyStateModel: (title: String, message: String) = ("", "")

    func viewAppeared() {}
    func toggleFavoriteState(for product: Product) {}
    func addToCart(product: Product) {}
    func openItem(product: Product) {}
    func refresh() {}
    func actionButtonTap() {}
    func fetchMoreContent() {}

}

#Preview {
    FavoritesView(viewModel: MockViewModel())
}

#endif
