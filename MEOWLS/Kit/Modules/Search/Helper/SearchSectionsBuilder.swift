//
//  SearchSectionsBuilder.swift
//  MEOWLS
//
//  Created by Artem Mayer on 19.10.2024.
//

import UIKit
import Combine

final class SearchSectionsBuilder {

    private let newPriceAttributes: [NSAttributedString.Key: Any] = {
        [.font: UIFont.systemFont(ofSize: 16, weight: .semibold), .foregroundColor: UIColor(resource: .textPrimary)]
    }()
    private let oldPriceAttributes: [NSAttributedString.Key: Any] = {
        [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(resource: .textSecondary),
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor(resource: .textSecondary)
        ]
    }()
    private let titleAttributes: [NSAttributedString.Key: Any] = {
        [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor(resource: .textPrimary)]
    }()
    private let titleBoldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
    private let subtitleAttributes: [NSAttributedString.Key: Any] = {
        [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: UIColor(resource: .textSecondary)]
    }()
    private let subtitleBoldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]

    private let numberOfCategoryColumns: CGFloat = 2
    private let minimumLineSpacing: CGFloat = 8
    private let maximumEdgeInsets: CGFloat = 20
    private let horizontalInset: CGFloat = 16
    private var productsSectionInsets: UIEdgeInsets {
        let cellInsets = (viewSize.width - numberOfCategoryColumns * ProductCell.standartSize.width) / 2.0
        let borderInsets = min(cellInsets, maximumEdgeInsets)
        return UIEdgeInsets(top: horizontalInset, left: borderInsets, bottom: horizontalInset, right: borderInsets)
    }

    private var viewSize: CGSize = .zero
    private var categories: [SearchSuggestion]?
    private var products: [Product]?
    private var favoritesService: FavoritesServiceProtocol?
    private var categoryHandler: (Int) -> Void = { _ in }
    private var headerTapHandler: VoidClosure = {}

    @discardableResult
    func setCategories(_ categories: [SearchSuggestion]) -> Self {
        self.categories = categories
        return self
    }

    @discardableResult
    func setProducts(_ products: [Product]) -> Self {
        self.products = products
        return self
    }

    @discardableResult
    func setViewSize(_ viewSize: CGSize) -> Self {
        self.viewSize = viewSize
        return self
    }

    @discardableResult
    func setFavoriteService(_ favoritesService: FavoritesServiceProtocol) -> Self {
        self.favoritesService = favoritesService
        return self
    }

    @discardableResult
    func setCategoryHandler(_ categoryHandler: @escaping (Int) -> Void) -> Self {
        self.categoryHandler = categoryHandler
        return self
    }

    @discardableResult
    func setHeaderTapHandler(_ headerTapHandler: @escaping VoidClosure) -> Self {
        self.headerTapHandler = headerTapHandler
        return self
    }

    func build() -> [SearchModel.Section] {
        var sections: [SearchModel.Section] = []

        if let categoriesSection = buildCategoriesSection() {
            sections.append(categoriesSection)
        }
        if let productsSection = buildProductsSection() {
            sections.append(productsSection)
        }

        return sections
    }

}

private extension SearchSectionsBuilder {

    func buildCategoriesSection() -> SearchModel.Section? {
        guard let row = buildCategoriesRow() else {
            return nil
        }

        return SearchModel.Section(items: [row])
    }

    func buildProductsSection() -> SearchModel.Section? {
        guard let products else {
            return nil
        }

        #if Store

        guard let favoritesService else {
            fatalError("FavoritesService shouldn't be nil")
        }

        let productsRows = products.map({ buildProductRow(from: $0, favoritesService: favoritesService) })

        #else

        let productsRows = products.map({ buildProductRow(from: $0) })

        #endif

        if !productsRows.isEmpty {
            let severalProducts = products.count == 1
            let search = severalProducts ? Strings.Catalogue.Searching.findGood : Strings.Catalogue.Searching.findGoods
            let title = "\(search) \(String(format: Strings.Catalogue.Searching.itemsCount, products.count))"
            let buttonTitleAttributes = AttributeContainer([.font: UIFont.systemFont(ofSize: 16),
                                                            .foregroundColor: UIColor(resource: .accentPrimary)])
            let buttonTitle = AttributedString(Strings.Catalogue.Categories.all, attributes: buttonTitleAttributes)
            let headerViewModel = DomainBoldWithButtonCollectionHeader.ViewModel(title: title,
                                                                                 buttonTitle: buttonTitle,
                                                                                 buttonTapHandler: headerTapHandler)

            let productsHeaderModel = SearchModel.CollectionHeaderModel(viewModel: headerViewModel,
                                                                        hasProducts: !products.isEmpty,
                                                                        hasCategories: !categories.isNilOrEmpty,
                                                                        minimumLineSpacing: minimumLineSpacing,
                                                                        insetForProductSection: productsSectionInsets)
            
            return SearchModel.Section(header: productsHeaderModel, items: productsRows)
        }

        return nil
    }

    func buildCategoriesRow() -> SearchModel.Row? {
        guard let categories, !categories.isEmpty else {
            return nil
        }

        let tagsModels: [SearchTagCell.ViewModel] = categories.map { suggestion in
            let categoryProductsCount = suggestion.redirect.productsSet?.category?.productsCount?.toString

            let title = NSMutableAttributedString(string: suggestion.text, attributes: titleAttributes)
            var subtitle: NSMutableAttributedString?

            if let additionalText = suggestion.additionalText {
                subtitle = NSMutableAttributedString(string: additionalText, attributes: subtitleAttributes)
            }

            suggestion.highlightedTexts?.forEach { highlightedText in

                if let substringRange = suggestion.text.range(of: highlightedText) {
                    let range = NSRange(substringRange, in: suggestion.text)
                    title.addAttributes(titleBoldAttributes, range: range)
                }
                if let text = suggestion.additionalText, let substringRange = text.range(of: highlightedText) {
                    let range = NSRange(substringRange, in: text)
                    subtitle?.addAttributes(subtitleBoldAttributes, range: range)
                }
            }

            return SearchTagCell.ViewModel(title: title, subtitle: subtitle, value: categoryProductsCount)
        }

        let calculator = SearchTagsSizeCalculator(tagsCellsModels: tagsModels, collectionViewWidth: viewSize.width)

        return .categories(.init(calculator: calculator, cellModels: tagsModels, categoryHandler: categoryHandler))
    }

    #if Store

    func buildProductRow(from product: Product, favoritesService: FavoritesServiceProtocol) -> SearchModel.Row {
        let baseModel = buildBaseProductCellModel(from: product)

        let favoritesTapHandler: VoidClosure? = { [weak favoritesService] in
            favoritesService?.toggle(item: product, completion: nil)
        }

        let checkedIsFavoriteHandler: (() -> Bool)? = { [weak favoritesService] in
            favoritesService?.isFavorite(item: product) ?? false
        }

        let favoritesPublisher = favoritesService.favoritesTogglePublisher
            .filter { favorites, _ in
                favorites?.contains(where: { $0.identifier == product.id }) ?? false
            }
            .map { _, isFavorite in
                isFavorite
            }
            .eraseToAnyPublisher()

        let cellModel = ProductCell.ViewModel(cellViewType: baseModel.cellViewType,
                                              isTransparent: baseModel.isTransparent,
                                              isBordered: baseModel.isBordered,
                                              images: baseModel.images,
                                              isVariablePrice: baseModel.isVariablePrice,
                                              newPrice: baseModel.newPrice,
                                              oldPrice: baseModel.oldPrice,
                                              discount: baseModel.discount,
                                              badges: baseModel.badges,
                                              productName: baseModel.productName,
                                              favoritesPublisher: favoritesPublisher,
                                              favoritesTapHandler: favoritesTapHandler,
                                              checkedIsFavoriteClosure: checkedIsFavoriteHandler,
                                              cartTapHandler: baseModel.cartTapHandler,
                                              productTapHandler: baseModel.productTapHandler)

        return .product(cellModel)
    }

    #else

    func buildProductRow(from product: Product) -> SearchModel.Row {
        SearchModel.Row.product(buildBaseProductCellModel(from: product))
    }

    #endif

    func buildBaseProductCellModel(from product: Product) -> ProductCell.ViewModel {
        var attributedNewPrice: NSAttributedString?
        var attributedOldPrice: NSAttributedString?
        var newPrice = product.newPrice()?.asPrice()
        var oldPriceFormatted = product.oldPrice()?.asPrice()
        oldPriceFormatted = oldPriceFormatted?.replacingOccurrences(of: " ", with: "\u{00a0}")

        if product.isVariablePrice == true, let price = newPrice {
            newPrice = String(format: Strings.Catalogue.Product.priceFrom, price)
        }

        if let newPrice {
            attributedNewPrice = NSMutableAttributedString(string: newPrice, attributes: newPriceAttributes)

            if let oldPrice = oldPriceFormatted {
                attributedOldPrice = NSMutableAttributedString(string: oldPrice, attributes: oldPriceAttributes)
            }
        }

        let cartTapHandler: VoidClosure = {

        }

        return ProductCell.ViewModel(cellViewType: .compact,
                                     isTransparent: false,
                                     isBordered: false,
                                     images: product.images,
                                     isVariablePrice: product.isVariablePrice,
                                     newPrice: attributedNewPrice,
                                     oldPrice: attributedOldPrice,
                                     discount: product.discountFormatted(),
                                     badges: product.defaultVariant?.badges,
                                     productName: product.name,
                                     favoritesPublisher: nil,
                                     favoritesTapHandler: nil,
                                     checkedIsFavoriteClosure: nil,
                                     cartTapHandler: cartTapHandler,
                                     productTapHandler: nil)
    }

}
