//
//  ProductImageSlider.swift
//  MEOWLS
//
//  Created by Artem Mayer on 22.10.2024.
//

import UIKit
import SnapKit
import ImageSlideshow

final class ProductImageSlider: NiblessView {

    private var favoritesHandler: VoidClosure?

    override init() {
        super.init()

        setupUI()
    }

    private var favoriteImageConstraint: Constraint?
    private var promoBadgeStackContainerConstraint: Constraint?

    private lazy var imageSlider: ImageSlideshow = {
        let slider = ImageSlideshow()
        slider.pageIndicator = DomainPageControl()
        slider.contentScaleMode = .scaleAspectFit
        slider.layer.cornerRadius = 12
        slider.layer.masksToBounds = true
        slider.preload = .fixed(offset: 1)
        slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentFullScreenImage)))

        return slider
    }()
    private lazy var favoriteContainer = UIView()
    private lazy var favoriteImage: UIImageView = {
        let image = UIImage(resource: .heartButtonChecked).withRenderingMode(.alwaysTemplate)
        return UIImageView(image: image)
    }()
    private lazy var favoriteLoader = LoaderWrapper(loaderSize: .favoritesIconSize)
    private lazy var favoriteButton = UIButton()
    private lazy var promoBadgeStackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4

        return stackView
    }()

}

extension ProductImageSlider {

    var promoContainerIsHidden: Bool {
        get { promoBadgeStackContainer.isHidden }
        set { promoBadgeStackContainer.isHidden = newValue }
    }

    var favoriteButtonIsUserInteractionEnabled: Bool {
        get { favoriteButton.isUserInteractionEnabled }
        set { favoriteButton.isUserInteractionEnabled = newValue }
    }

    var favoritesTapHandler: VoidClosure? {
        get { nil }
        set { favoritesHandler = newValue }
    }

    var favoritesContainerIsHidden: Bool {
        get { favoriteContainer.isHidden }
        set { favoriteContainer.isHidden = newValue }
    }

    func updateHorizontalInset(_ inset: Double) {
        favoriteImageConstraint?.update(inset: inset)
        promoBadgeStackContainerConstraint?.update(inset: inset)
    }

    func setFavoriteValue(_ isFavorite: Bool) {
        favoriteImage.tintColor = UIColor(resource: isFavorite ? .accentTertiary : .textDisabled)
        favoriteButton.accessibilityValue = isFavorite ? "1" : "0"
    }

    func setImageInputs(_ inputs: [InputSource]) {
        imageSlider.setImageInputs(inputs)
    }

    func setBadges(_ badges: [Product.ProductVariant.Badge]?) {
        removeBadges()

        if let badges, !badges.isEmpty {
            badges.forEach { badge in
                let badgeView = DomainBadgeView(with: .init(size: .small, type: .square, color: .green(opaque: false)))
                badgeView.title = badge.title
                promoBadgeStackContainer.addArrangedSubview(badgeView)
            }
            promoBadgeStackContainer.isHidden = false
        } else {
            promoBadgeStackContainer.isHidden = true
        }
    }

    func stopLoader() {
        favoriteLoader.hideLoading()
    }

    func toSleep() {
        imageSlider.toSleep()
    }

    func closeView() {
        imageSlider.closeView()
    }

    func reset() {
        removeBadges()
        promoBadgeStackContainer.isHidden = true
        imageSlider.setImageInputs([])
        setFavoriteValue(false)
    }

}

private extension ProductImageSlider {

    func setupUI() {
        favoriteButton.backgroundColor = .clear
        favoriteButton.addTarget(self, action: #selector(tapFavorite), for: .touchUpInside)

        setupConstraints()
    }

    func setupConstraints() {
        addSubview(imageSlider)
        addSubview(favoriteContainer)
        addSubview(promoBadgeStackContainer)
        favoriteContainer.addSubview(favoriteImage)
        favoriteContainer.addSubview(favoriteButton)

        imageSlider.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
            make.width.equalTo(imageSlider.snp.height)
        }
        favoriteContainer.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.top.trailing.equalToSuperview()
        }
        favoriteImage.snp.makeConstraints { make in
            make.size.equalTo(20)
            favoriteImageConstraint = make.top.trailing.equalToSuperview().inset(10).constraint
        }
        favoriteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        promoBadgeStackContainer.snp.makeConstraints { make in
            promoBadgeStackContainerConstraint = make.leading.equalToSuperview().inset(10).constraint
            make.trailing.lessThanOrEqualTo(favoriteImage.snp.leading).offset(-10)
            make.centerY.equalTo(favoriteImage.snp.centerY)
        }
    }

    func removeBadges() {
        promoBadgeStackContainer.arrangedSubviews.forEach {
            promoBadgeStackContainer.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

}

private extension ProductImageSlider {

    @objc
    func tapFavorite() {
        favoriteButton.isUserInteractionEnabled = false
        favoriteLoader.showLoadingOnCenter(inView: favoriteImage)

        favoritesHandler?()
    }

}

private extension ProductImageSlider {

    @objc
    func presentFullScreenImage() {
        guard let presentationViewController = presentationViewController(from: next) else {
            return
        }

        let vc = imageSlider.presentFullScreenController(from: presentationViewController)
        vc.closeButton.setImage(UIImage(resource: .navigationCloseRounded), for: .normal)
    }

    func presentationViewController(from responder: UIResponder?) -> UIViewController? {
        guard let responder else {
            return nil
        }

        if let viewController = responder as? UIViewController {
            return viewController
        } else if let navigationController = responder as? UINavigationController {
            return navigationController
        } else {
            return presentationViewController(from: responder.next)
        }
    }

}
