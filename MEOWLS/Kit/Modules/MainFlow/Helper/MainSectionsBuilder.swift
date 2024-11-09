//
//  MainSectionsBuilder.swift
//  MEOWLS
//
//  Created by Artem Mayer on 02.10.2024.
//

import UIKit

final class MainSectionsBuilder {

    private let newPriceAttributes: [NSAttributedString.Key: Any] = {
        [.font: UIFont.systemFont(ofSize: 16, weight: .semibold), .foregroundColor: Colors.Text.textPrimary.color]
    }()
    private let oldPriceAttributes: [NSAttributedString.Key: Any] = {
        [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: Colors.Text.textSecondary.color,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: Colors.Text.textSecondary.color
        ]
    }()

    typealias Constants = MainModel.Constants
    typealias Row = MainModel.Row
    typealias VerticalItemModel = BannerVerticalCollectionCell.CollectionItem
    typealias VerticalModel = BannerVerticalCollectionCell.ViewModel
    typealias HorizontalModel = BannerHorizontalCollectionCell.ViewModel
    typealias SliderModel = BannerCollectionViewCell.ViewModel
    typealias TagModel = BannerTagsCollectionCell.ViewModel
    typealias NavigationHandler = (MainBanner.PlaceType?, Redirect?, _ value: Any?) -> ()

    private var banners: [MainBanner] = []
    private var viewSize: CGSize?
    private var imagesSize: [String: CGSize] = [:]
    private var favoritesService: FavoritesServiceProtocol?
    private var navigationHandler: NavigationHandler?

    @discardableResult
    func setBanners(_ banners: [MainBanner]) -> Self {
        self.banners = banners
        return self
    }

    @discardableResult
    func setViewSize(_ viewSize: CGSize) -> Self {
        self.viewSize = viewSize
        return self
    }

    @discardableResult
    func setImagesSize(_ imagesSize: [String: CGSize]) -> Self {
        self.imagesSize = imagesSize
        return self
    }

    @discardableResult
    func setFavoritesService(_ favoritesService: FavoritesServiceProtocol) -> Self {
        self.favoritesService = favoritesService
        return self
    }

    @discardableResult
    func setNavigationHandler(_ navigationHandler: @escaping NavigationHandler) -> Self {
        self.navigationHandler = navigationHandler
        return self
    }

    func build() -> [MainModel.Section] {
        guard let viewSize, let favoritesService, navigationHandler != nil, !banners.isEmpty else {
            return []
        }

        var section = MainModel.Section()

        banners.forEach { banner in
            let isKnownType = banner.placeType != .undefined
            if let headerRow = buildHeader(banner, completion: navigationHandler), isKnownType {
                section.append(headerRow)
            }

            let row: MainModel.Row?

            switch banner.placeType {
            case .bannersHorizontal:
                row = buildSlider(banner, viewSize: viewSize)

            case .productsCollection:
                row = buildProductsSlider(banner, favoritesService: favoritesService)

            case .bannersVertical, .singleBanner:
                row = buildVertical(banner, viewSize: viewSize)

            case .categories:
                row = buildTags(banner)

            default:
                row = nil

            }

            if let row {
                section.append(row)
            }
        }

        return [section]
    }

}

private extension MainSectionsBuilder {

    func buildHeader(_ banner: MainBanner, completion: NavigationHandler?) -> Row? {
        guard let headerTitle = banner.title else {
            return nil
        }

        let inset = Constants.DomainHeader.inset
        let height = Constants.DomainHeader.height + inset.top + inset.bottom

        return .header(.init(title: headerTitle, edge: Constants.DomainHeader.inset, cellHeight: height))
    }

    func buildSlider(_ banner: MainBanner, viewSize: CGSize) -> Row? {
        guard let banners = banner.banners else {
            return nil
        }

        let imageSize = imagesSize[banner.id]
        let itemWidth = viewSize.width - Constants.Slider.itemInset.left - Constants.Slider.itemInset.right
        let itemAspectRatio = (imageSize?.height ?? 1) / (imageSize?.width ?? 1)
        let itemHeight = round(itemWidth * itemAspectRatio)
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        let collectionInset = Constants.Slider.inset(for: banner.uiSettings?.spasings)
        let collectionHeight = itemHeight + collectionInset.top + collectionInset.bottom
        let slidingTimeout = Constants.Slider.autoSlidingTimeout(for: banner.uiSettings)

        let dataSource = banners.compactMap { childBanner -> SliderModel? in
            let url = getImageURL(for: childBanner.image, with: itemWidth)
            let tapClosure: VoidClosure = { [weak self] in
                self?.navigationHandler?(banner.placeType, childBanner.redirect, nil)
            }

            return .init(url: url, tapClosure: tapClosure)
        }

        let model = HorizontalModel(collectionInset: collectionInset,
                                    itemSize: itemSize,
                                    collectionHeight: collectionHeight,
                                    minimumLineSpacing: Constants.Slider.spacing,
                                    needAutoCorrection: true,
                                    state: .automaticSlider(dataSource: dataSource, scrollingInterval: slidingTimeout))

        return .slider(.init(cellModel: model, bannerID: banner.id))
    }

    func buildTags(_ banner: MainBanner) -> Row? {
        guard let categories = banner.categories else {
            return nil
        }

        let itemSize = CGSize(width: Constants.Tags.estimatedItemWidth, height: Constants.Tags.itemHeight)
        let spacing = Constants.Tags.spacing
        let imageWidth = Constants.Tags.imageWidth
        let collectionInset = Constants.Tags.inset(for: banner.uiSettings?.spasings)
        let collectionHeight = Constants.Tags.itemHeight + collectionInset.top + collectionInset.bottom

        let dataSource = categories.map { category -> TagModel in
            let url = getImageURL(for: category.image, with: imageWidth)
            let tapClosure: VoidClosure = { [weak self] in
                self?.navigationHandler?(banner.placeType, nil, category)
            }

            return .init(url: url, label: category.name, tapClosure: tapClosure)
        }

        let model = HorizontalModel(collectionInset: collectionInset,
                                    itemSize: itemSize,
                                    collectionHeight: collectionHeight,
                                    minimumLineSpacing: spacing,
                                    needAutoCorrection: false,
                                    state: .tagsSlider(dataSource: dataSource))

        return .tagsSlider(.init(cellModel: model, bannerID: banner.id))
    }

    func buildProductsSlider(_ banner: MainBanner, favoritesService: FavoritesServiceProtocol) -> Row? {
        guard let products = banner.products else {
            return nil
        }

        let itemSize = CGSize(width: Constants.ProductsSlider.itemWidth, height: ProductCell.standartSize.height)
        let hasHeader = banner.title != nil
        var collectionInset = Constants.commonInsets
        collectionInset.top = hasHeader ? 0 : collectionInset.top
        let collectionHeight = ProductCell.standartSize.height + collectionInset.top + collectionInset.bottom

        let dataSource = getProductModel(products, favoritesService: favoritesService)

        let model = HorizontalModel(collectionInset: collectionInset,
                                    itemSize: itemSize,
                                    collectionHeight: collectionHeight,
                                    minimumLineSpacing: Constants.Slider.spacing,
                                    needAutoCorrection: false,
                                    state: .productSlider(dataSource: dataSource))

        return .productsSlider(.init(cellModel: model, bannerID: banner.id))
    }

    func buildVertical(_ banner: MainBanner, viewSize: CGSize) -> Row {
        let itemWidth = viewSize.width - Constants.commonInsets.left - Constants.commonInsets.right
        let gridNumbers = banner.uiSettings?.metrics?.compactMap({ $0.width }) ?? []
        let verticalModel = buildVerticalDataSource(from: banner, gridNumbers: gridNumbers, itemWidth: itemWidth)

        return .verticalBanners(.init(cellModel: verticalModel, bannerID: banner.id))
    }

    func buildVerticalDataSource(from banner: MainBanner, gridNumbers: [Double], itemWidth: CGFloat) -> VerticalModel {
        let hasHeader = banner.title != nil
        var collectionInset = Constants.commonInsets
        collectionInset.top = hasHeader ? 0 : collectionInset.top

        let minimumInteritemSpacing = Constants.VerticalBanners.verticalSpacing
        let minimumLineSpacing = Constants.VerticalBanners.horizontalSpacing

        let shortItemWidth = itemWidth - minimumLineSpacing

        var collectionHeight: CGFloat = 0
        var lineCount = 0
        var currentLine = 0
        var dataSource: [VerticalItemModel] = []

        if let childBanners = banner.banners {
            let itemHeight = itemWidth / Constants.VerticalBanners.multipleItemsRatio

            dataSource = childBanners.enumerated().compactMap { (index, childBanner) -> VerticalItemModel? in
                let computedItemWidth: CGFloat

                if let gridItemWidth = gridNumbers[safe: index], gridItemWidth != 1 {
                    computedItemWidth = shortItemWidth * gridItemWidth

                    if currentLine == 0 {
                        lineCount += 1
                        collectionHeight += itemHeight
                        currentLine += 1
                    } else {
                        currentLine = 0
                    }

                } else {
                    computedItemWidth = itemWidth
                    currentLine = 0
                    lineCount += 1
                    collectionHeight += itemHeight
                }

                let url = getImageURL(for: childBanner.image, with: computedItemWidth)
                let tapClosure: VoidClosure? = { [weak self] in
                    self?.navigationHandler?(childBanner.placeType, childBanner.redirect, nil)
                }
                let size = CGSize(width: computedItemWidth, height: itemHeight)

                return .init(cellModel: .init(url: url, tapClosure: tapClosure), size: size)
            }
        } else if let url = getImageURL(for: banner.image, with: itemWidth) {

            let itemHeight = itemWidth / Constants.VerticalBanners.singleItemRatio
            let size = CGSize(width: itemWidth, height: itemHeight)
            let tapClosure: VoidClosure? = { [weak self] in
                self?.navigationHandler?(banner.placeType, banner.redirect, nil)
            }

            collectionHeight = itemHeight
            dataSource = [.init(cellModel: .init(url: url, tapClosure: tapClosure), size: size)]
        }

        if lineCount > 1 {
            collectionHeight += (CGFloat(lineCount) - 1) * minimumInteritemSpacing
        }
        collectionHeight += collectionInset.top + collectionInset.bottom

        return VerticalModel(collectionInset: collectionInset,
                             collectionHeight: collectionHeight,
                             minimumInteritemSpacing: minimumInteritemSpacing,
                             minimumLineSpacing: minimumLineSpacing,
                             dataSource: dataSource)
    }

}

private extension MainSectionsBuilder {

    func getProductModel(_ products: [Product], favoritesService: FavoritesServiceProtocol) -> [ProductCell.ViewModel] {
        products.compactMap { product -> ProductCell.ViewModel? in
            let productTapClosure: VoidClosure = { [weak self] in
                self?.navigationHandler?(.productsCollection, nil, product)
            }
            let checkedIsFavoriteHandler: () -> Bool = { [favoritesService] in
                favoritesService.isFavorite(item: product)
            }
            let favoritesTapHandler: VoidClosure = { [favoritesService] in
                favoritesService.toggle(item: product, completion: nil)
            }
            let favoritesPublisher = favoritesService.favoritesTogglePublisher
                .filter { favorites, _ in
                    favorites?.contains(where: { $0.identifier == product.id }) ?? false
                }
                .map { _, isFavorite in
                    isFavorite
                }
                .eraseToAnyPublisher()

            var attributedNewPrice: NSAttributedString?
            var attributedOldPrice: NSAttributedString?
            var newPrice = product.newPrice()?.asPrice
            let oldPrice = product.oldPrice()?.asPrice

            if product.isVariablePrice == true, let price = newPrice {
                newPrice = String(format: Strings.Catalogue.Product.priceFrom, price)
            }

            if let newPrice {
                attributedNewPrice = NSMutableAttributedString(string: newPrice, attributes: newPriceAttributes)

                if let oldPrice {
                    attributedOldPrice = NSMutableAttributedString(string: oldPrice, attributes: oldPriceAttributes)
                }
            }

            return ProductCell.ViewModel(cellViewType: .expanded,
                                         isTransparent: false,
                                         isBordered: true,
                                         images: product.images,
                                         isVariablePrice: product.isVariablePrice,
                                         newPrice: attributedNewPrice,
                                         oldPrice: attributedOldPrice,
                                         discount: product.discountFormatted(),
                                         badges: product.defaultVariant?.badges,
                                         productName: product.name,
                                         favoritesPublisher: favoritesPublisher,
                                         favoritesTapHandler: favoritesTapHandler,
                                         checkedIsFavoriteClosure: checkedIsFavoriteHandler,
                                         cartTapHandler: nil,
                                         productTapHandler: productTapClosure)
        }
    }

    func getImageURL(for itemImage: ItemImage?, with width: CGFloat) -> URL? {
        let edge = width * UIScreen.main.scale
        return itemImage?.scale(factor: .pixels(edge)).url?.toURL ?? itemImage?.original?.toURL
    }

}
