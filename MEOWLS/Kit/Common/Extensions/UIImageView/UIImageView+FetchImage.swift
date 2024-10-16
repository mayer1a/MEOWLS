//
//  UIImageView+FetchImage.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.10.2024.
//

import Kingfisher

public extension UIImageView {

    typealias KFCompletion = ((Result<RetrieveImageResult, KingfisherError>) -> Void)

    enum FetchOption {
        case template
        case fade(TimeInterval = 0.3)
        case cache
    }

    func fetchImage(_ url: URL?,
                    placeholder: UIImage? = nil,
                    options: [FetchOption] = [],
                    completion: KFCompletion? = nil) {

        fetch(url: url, placeholder: placeholder, options: options, completion)
    }

    func fetchImage(_ imageItem: ItemImage?,
                    defaultWidth: CGFloat = 64.0,
                    placeholder: UIImage? = nil,
                    options: [FetchOption] = [],
                    completion: KFCompletion? = nil) {

        let width = bounds.width > 0 ? bounds.width : defaultWidth
        let edge = width * UIScreen.main.scale
        let url = imageItem?.scale(factor: .pixels(edge)).url?.toURL

        fetch(url: url, placeholder: placeholder, options: options, completion)
    }

    private func fetch(url: URL?, placeholder: UIImage?, options: [FetchOption], _ completion: KFCompletion?) {

        var options: KingfisherOptionsInfo = options.flatMap { option -> KingfisherOptionsInfo in
            switch option {
            case .template:
                return [.imageModifier(RenderingModeImageModifier(renderingMode: .alwaysTemplate))]

            case .fade(let duration):
                return [.transition(.fade(duration))]

            case .cache:
                return .cachedOptions

            }
        }

        options.append(.onFailureImage(placeholder))

        kf.setImage(with: url, placeholder: placeholder, options: options, completionHandler: completion)
    }

}
