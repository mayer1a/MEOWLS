//
//  BannerHorizontalCollectionCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit

extension BannerHorizontalCollectionCell {

    struct ViewModel {
        let collectionInset: UIEdgeInsets
        let itemSize: CGSize
        let collectionHeight: CGFloat
        let minimumLineSpacing: CGFloat
        /// Is it necessary to adjust the cell in the center when scrolling
        let needAutoCorrection: Bool

        let state: State

        enum State {
            /// Collection with an endless feed and automatic scrolling of banners
            case automaticSlider(dataSource: [BannerCollectionViewCell.ViewModel], scrollingInterval: Double)
            /// Regular collection with banners
            case slider(dataSource: [BannerCollectionViewCell.ViewModel])
            /// Regular collection with product cells
            case productSlider(dataSource: [BannerProductCollectionViewCell.ViewModel])
            /// Regular collection with tags cells
            case tagsSlider(dataSource: [BannerTagsCollectionCell.ViewModel])
        }
    }

}
