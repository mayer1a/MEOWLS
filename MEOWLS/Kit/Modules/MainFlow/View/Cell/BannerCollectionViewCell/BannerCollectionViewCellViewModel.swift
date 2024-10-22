//
//  BannerCollectionViewCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit

extension BannerCollectionViewCell {

    struct ViewModel {
        let url: URL?
        let placeHolder: UIImage?
        let tapClosure: VoidClosure?
        let label: String?

        init(url: URL?, placeHolder: UIImage? = nil, tapClosure: VoidClosure? = nil, label: String? = nil) {
            self.url = url
            self.placeHolder = placeHolder
            self.tapClosure = tapClosure
            self.label = label
        }
    }

}
