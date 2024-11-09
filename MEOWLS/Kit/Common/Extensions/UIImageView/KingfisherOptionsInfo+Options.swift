//
//  KingfisherOptionsInfo+Options.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.10.2024.
//

import Kingfisher

extension KingfisherOptionsInfo {

    static let cachedOptions: KingfisherOptionsInfo = {
        [.originalCache(ImageCache.default), .cacheOriginalImage]
    }()

    static func cachedFadedOptions(with placeholder: UIImage?) -> KingfisherOptionsInfo {
        [.transition(.fade(0.3)), .onFailureImage(placeholder), .onlyLoadFirstFrame] + cachedOptions
    }

}
