//
//  FavoritesCellFactory.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

struct FavoritesCellFactory {

    static func buildCellModels(from products: [Product]) -> [ProductListingCell.ViewModel] {
        products.map { buildCellModel(from: $0) }
    }

    private static func buildCellModel(from product: Product) -> ProductListingCell.ViewModel {
        ProductListingCell.ViewModel(product: product,
                                     name: product.name,
                                     newPrice: product.newPrice()?.asPrice ?? "",
                                     oldPrice: product.oldPrice()?.asPrice,
                                     discount: product.discountFormatted(),
                                     badges: product.defaultVariant?.badges,
                                     images: product.images)
    }

}
