//
//  LoaderWrapper.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.09.2024.
//

import UIKit
import SnapKit

public final class LoaderWrapper {

    public init(loaderSize: LoaderSize = .large) {
        self.loaderSize = loaderSize
        self.loadingImage = Images.loader.image
    }

    private var loadingView: UIView?
    private let loadingImage: UIImage?
    private let loaderSize: LoaderSize

    public func showLoadingOnCenter(inView view: UIView) {
        hideLoading()

        let loadingView = UIImageView(image: loadingImage)
        loadingView.rotate()

        loadingView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(loadingView)

        loadingView.snp.makeConstraints { make in
            make.centerX.equalTo(view.layoutMarginsGuide.snp.centerX)
            make.centerY.equalTo(view.layoutMarginsGuide.snp.centerY)
            make.size.equalTo(loaderSize.rawValue)
        }

        self.loadingView = loadingView

        view.layoutIfNeeded()
    }

    public func hideLoading() {
        loadingView?.stopRotating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }

}

public extension LoaderWrapper {

    enum LoaderSize: CGFloat {
        case standard = 26.0
        case favoritesIconSize = 29.0
        case large = 48.0
    }

}
