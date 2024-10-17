//
//  MainSectionsBuilder.swift
//  MEOWLS
//
//  Created by Artem Mayer on 02.10.2024.
//

import UIKit

struct MainSectionsBuilder {

    typealias Constants = MainModel.Constants
    typealias Row = MainModel.Row
    typealias NavigationHandler = (MainBanner.PlaceType?, Redirect?, _ value: Any?) -> ()
    typealias VerticalItemModel = BannerVerticalCollectionCell.CollectionItem
    typealias VerticalModel = BannerVerticalCollectionCell.ViewModel
    typealias HorizontalModel = BannerHorizontalCollectionCell.ViewModel
    typealias SliderModel = BannerCollectionViewCell.ViewModel
    typealias ProductModel = BannerProductCollectionViewCell.ViewModel
    typealias TagModel = BannerTagsCollectionCell.ViewModel

    static func buildHeader(_ banner: MainBanner, completion: NavigationHandler?) -> Row? {
        guard let headerTitle = banner.title else {
            return nil
        }

        let inset = Constants.DomainHeader.inset
        let height = Constants.DomainHeader.height + inset.top + inset.bottom

        return .header(.init(title: headerTitle, edge: Constants.DomainHeader.inset, cellHeight: height))
    }

    static func buildTags(_ banner: MainBanner, completion: NavigationHandler?) -> Row {

        let itemHeight = Constants.Tags.itemHeight
        let itemSize = CGSize(width: Constants.Tags.estimatedItemWidth, height: itemHeight)
        let spacing = Constants.Tags.spacing
        let imageWidth = Constants.Tags.imageWidth

        let collectionInset = Constants.Tags.inset(for: banner.uiSettings?.spasings)
        let collectionHeight = itemHeight + collectionInset.top + collectionInset.bottom

        var dataSource = [TagModel]()

        banner.categories?.forEach { category in
            let url = getImageURL(for: category.image, with: imageWidth)

            let tapClosure: VoidClosure? = { [completion] in
                completion?(banner.placeType, nil, category)
            }

            dataSource.append(.init(url: url, label: category.name, tapClosure: tapClosure))
        }

        let model = HorizontalModel(collectionInset: collectionInset,
                                    itemSize: itemSize,
                                    collectionHeight: collectionHeight,
                                    minimumLineSpacing: spacing,
                                    needAutoCorrection: false,
                                    state: .tagsSlider(dataSource: dataSource))

        return .tagsSlider(.init(cellModel: model, bannerID: banner.id))
    }

    static func buildSlider(_ banner: MainBanner,
                            imageSize: CGSize?,
                            size: CGSize,
                            completion: NavigationHandler?) -> Row {

        let itemWidth = size.width - Constants.Slider.itemInset.left - Constants.Slider.itemInset.right
        let itemAspectRatio = (imageSize?.height ?? 1) / (imageSize?.width ?? 1)
        let itemHeight = itemWidth * itemAspectRatio
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        let spacing = Constants.Slider.spacing

        let collectionInset = Constants.Slider.inset(for: banner.uiSettings?.spasings)
        let collectionHeight = itemHeight + collectionInset.top + collectionInset.bottom

        var dataSource = [SliderModel]()

        banner.banners?.forEach { childBanner in
            guard let url = getImageURL(for: childBanner.image, with: itemWidth) else {
                return
            }

            let tapClosure: VoidClosure? = { [completion] in
                completion?(banner.placeType, childBanner.redirect, nil)
            }
            dataSource.append(.init(url: url, tapClosure: tapClosure))
        }

        var slidingTimeout: Double = 5000

        if let interval = banner.uiSettings?.autoSlidingTimeout?.toDouble, interval != 0 {
            slidingTimeout = interval
        }

        let model = HorizontalModel(collectionInset: collectionInset,
                                    itemSize: itemSize,
                                    collectionHeight: collectionHeight,
                                    minimumLineSpacing: spacing,
                                    needAutoCorrection: true,
                                    state: .automaticSlider(dataSource: dataSource, scrollingInterval: slidingTimeout))

        return .slider(.init(cellModel: model, bannerID: banner.id))
    }

    static func buildProductsSlider(_ banner: MainBanner,
                                    favoritesService: FavoritesServiceProtocol,
                                    completion: NavigationHandler?) -> Row? {

        guard let products = banner.products else {
            return nil
        }

        let itemHeight = Constants.ProductsSlider.itemHeight
        let itemSize = CGSize(width: Constants.ProductsSlider.itemWidth, height: itemHeight)
        let spacing = Constants.Slider.spacing

        let hasHeader = banner.title != nil
        var collectionInset = Constants.commonInsets
        collectionInset.top = hasHeader ? 0 : collectionInset.top
        let collectionHeight = itemHeight + collectionInset.top + collectionInset.bottom

        let dataSource = getProductModel(products, favoritesService: favoritesService, completion: completion)

        let model = HorizontalModel(collectionInset: collectionInset,
                                    itemSize: itemSize,
                                    collectionHeight: collectionHeight,
                                    minimumLineSpacing: spacing,
                                    needAutoCorrection: false,
                                    state: .productSlider(dataSource: dataSource))

        return .productsSlider(.init(cellModel: model, bannerID: banner.id))
    }

    static func buildVertical(_ banner: MainBanner, size: CGSize, completion: NavigationHandler?) -> Row {
        let wideItemWidth = size.width - Constants.commonInsets.left - Constants.commonInsets.right
        var gridNumbers = [Double]()

        if let gridArray = banner.uiSettings?.metrics {
            gridNumbers = gridArray.compactMap { $0.width }
        }

        let settings = VerticalSettings(gridNumbers: gridNumbers, wideItemWidth: wideItemWidth, completion: completion)
        let verticalModel = buildVerticalDataSource(from: banner, settings: settings)

        return .verticalBanners(.init(cellModel: verticalModel, bannerID: banner.id))
    }

    private static func buildVerticalDataSource(from banner: MainBanner, settings: VerticalSettings) -> VerticalModel {

        let hasHeader = banner.title != nil
        var collectionInset = Constants.commonInsets
        collectionInset.top = hasHeader ? 0 : collectionInset.top

        let minimumInteritemSpacing = Constants.VerticalBanners.verticalSpacing
        let minimumLineSpacing = Constants.VerticalBanners.horizontalSpacing

        let shortItemWidth = settings.wideItemWidth - minimumLineSpacing

        var collectionHeight: CGFloat = 0
        var lineCount: CGFloat = 0
        var currentLine = 0
        var dataSource: [MainSectionsBuilder.VerticalItemModel] = []

        if let childBanners = banner.banners {
            let itemHeight = settings.wideItemWidth / Constants.VerticalBanners.multipleItemsRatio

            dataSource = childBanners.enumerated().compactMap { (index, childBanner) -> VerticalItemModel? in
                let itemWidth: CGFloat

                if let gridItemWidth = settings.gridNumbers[safe: index], gridItemWidth != 1 {
                    itemWidth = shortItemWidth * gridItemWidth

                    if currentLine == 0 {
                        lineCount += 1
                        collectionHeight += itemHeight
                        currentLine += 1
                    } else {
                        currentLine = 0
                    }

                } else {
                    itemWidth = settings.wideItemWidth
                    currentLine = 0
                    lineCount += 1
                    collectionHeight += itemHeight
                }

                guard let url = getImageURL(for: childBanner.image, with: itemWidth) else {
                    return nil
                }

                let tapClosure: VoidClosure? = { [completion = settings.completion] in
                    completion?(childBanner.placeType, childBanner.redirect, nil)
                }
                let size = CGSize(width: itemWidth, height: itemHeight)

                return .init(cellModel: .init(url: url, tapClosure: tapClosure), size: size)
            }
        } else if let url = getImageURL(for: banner.image, with: settings.wideItemWidth) {

            let itemHeight = settings.wideItemWidth / Constants.VerticalBanners.singleItemRatio
            let size = CGSize(width: settings.wideItemWidth, height: itemHeight)

            let tapClosure: VoidClosure? = { [completion = settings.completion] in
                completion?(banner.placeType, banner.redirect, nil)
            }

            collectionHeight += itemHeight
            dataSource = [.init(cellModel: .init(url: url, tapClosure: tapClosure), size: size)]
        }

        if lineCount > 1 {
            collectionHeight += (lineCount - 1) * minimumInteritemSpacing
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

    struct VerticalSettings {
        let gridNumbers: [Double]
        let wideItemWidth: CGFloat
        let completion: NavigationHandler?
    }

}

private extension MainSectionsBuilder {

    static func getProductModel(_ products: [Product],
                                favoritesService: FavoritesServiceProtocol,
                                completion: NavigationHandler?) -> [ProductModel] {

        products.compactMap { product -> ProductModel? in
            let defaultImageEdge: CGFloat = 148
            let edge = defaultImageEdge * UIScreen.main.scale

            guard let imageURL = product.images.first?.scale(factor: .pixels(edge)).url?.toURL else {
                return nil
            }

            let productTapClosure: VoidClosure = { [completion] in
                completion?(.productsCollection, nil, product)
            }

            let checkedIsFavoriteClosure: () -> Bool = { [favoritesService] in
                return favoritesService.isFavorite(item: product)
            }

            let favoriteTapClosure: VoidClosure = { [favoritesService] in
                favoritesService.toggle(item: product, completion: nil)
            }

            var oldPriceFormatted = product.oldPrice()
            var newPriceFormatted = product.newPrice()

            if oldPriceFormatted == newPriceFormatted {
                oldPriceFormatted = nil
            }

            if let price = newPriceFormatted {
                let priceFrom = Strings.Catalogue.Product.priceFrom
                newPriceFormatted = product.isVariablePrice ? String(format: priceFrom, price) : price
            }

            let favoritesTogglePublisher = favoritesService.favoritesTogglePublisher
                .filter { favorites, _ in
                    favorites?.contains(where: { $0.identifier == product.id }) ?? false
                }
                .map { _, isFavorite in
                    isFavorite
                }
                .eraseToAnyPublisher()

            return ProductModel(productImageURL: imageURL,
                                productTapClosure: productTapClosure,
                                checkedIsFavoriteClosure: checkedIsFavoriteClosure,
                                favoriteTapClosure: favoriteTapClosure,
                                favoritePublisher: favoritesTogglePublisher,
                                badges: product.defaultVariant?.badges,
                                oldPrice: oldPriceFormatted,
                                specialSale: product.discountFormatted(),
                                price: newPriceFormatted,
                                description: product.name)
        }
    }

    static func getImageURL(for itemImage: ItemImage?, with width: CGFloat) -> URL? {
        let edge = width * UIScreen.main.scale

        return itemImage?.scale(factor: .pixels(edge)).url?.toURL ?? itemImage?.original?.toURL
    }

}
