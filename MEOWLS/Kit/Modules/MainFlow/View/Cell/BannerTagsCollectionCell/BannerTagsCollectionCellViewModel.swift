//
//  BannerTagsCollectionCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit

extension BannerTagsCollectionCell {

    struct ViewModel {
        let url: URL?
        let placeHolder: UIImage?
        let label: String?
        let tapClosure: VoidClosure?

        init(url: URL?, placeHolder: UIImage? = nil, label: String? = nil, tapClosure: VoidClosure? = nil) {
            self.url = url
            self.placeHolder = placeHolder
            self.label = label
            self.tapClosure = tapClosure
        }
    }

}
