//
//  BannerVerticalCollectionCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit

extension BannerVerticalCollectionCell {

    struct ViewModel {
        let collectionInset: UIEdgeInsets
        let collectionHeight: CGFloat
        let minimumInteritemSpacing: CGFloat
        let minimumLineSpacing: CGFloat
        let dataSource: [CollectionItem]
    }

    struct CollectionItem {
        let cellModel: BannerCollectionViewCell.ViewModel
        let size: CGSize
    }

}
