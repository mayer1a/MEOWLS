//
//  DomainImageSliderCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 25.10.2024.
//

import UIKit
import Kingfisher

final class DomainImageSliderCell: NiblessCollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    private(set) lazy var imageView = UIImageView(frame: self.bounds)
    private lazy var placeholderImageView = UIImageView(frame: self.bounds)

}

extension DomainImageSliderCell {

    func set(image: ItemImage, placeholder: UIImage?) {
        imageView.image = nil
        imageView.alpha = 0
        placeholderImageView.image = placeholder
        placeholderImageView.alpha = 1

        imageView.fetchImage(image, placeholder: placeholder, options: [.cache]) { [weak self] result in
            if case .success(let imageResult) = result {
                self?.revealImageView(with: imageResult.cacheType)
            }
        }
    }

    func cancelLoading() {
        imageView.kf.cancelDownloadTask()
    }

}

private extension DomainImageSliderCell {

    func configure() {
        addSubview(placeholderImageView)
        addSubview(imageView)

        placeholderImageView.contentMode = .center
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }

    func revealImageView(with cacheType: CacheType) {
        let revealImageView = { [weak self] in
            self?.imageView.alpha = 1
            self?.placeholderImageView.alpha = 0
        }

        if cacheType.cached {
            revealImageView()
        } else {
            UIView.animate(withDuration: 0.3, animations: revealImageView)
        }
    }

    func reset() {
        cancelLoading()

        imageView.image = nil
        imageView.alpha = 0
        placeholderImageView.alpha = 1
    }

}
