//
//  LoaderWrapper.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.09.2024.
//

import UIKit
import SnapKit

final class LoaderWrapper {

    enum LoaderSize: CGFloat {
        case standard = 26.0
        case large = 48.0
    }

    init(loaderSize: LoaderSize = .large) {
        self.loaderSize = loaderSize
        self.loadingImage = UIImage(resource: .loader)
    }

    private var loadingView: UIView?
    private let loadingImage: UIImage?
    private let loaderSize: LoaderSize

    func showLoadingOnCenter(inView view: UIView) {
        hideLoading()

        let loadingView = UIImageView(image: loadingImage)
        loadingView.rotate()

        loadingView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(loadingView)

        loadingView.snp.makeConstraints { make in
            make.centerX.equalTo(view.layoutMarginsGuide.snp.centerX)
            make.centerY.equalTo(view.layoutMarginsGuide.snp.centerY)
            make.height.width.equalTo(loaderSize.rawValue)
        }

        self.loadingView = loadingView

        view.layoutIfNeeded()
    }

    func hideLoading() {
        loadingView?.stopRotating()
        loadingView?.removeFromSuperview()
        loadingView = nil
    }

}
