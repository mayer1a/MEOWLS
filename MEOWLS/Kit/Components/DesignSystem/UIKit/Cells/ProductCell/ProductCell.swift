//
//  ProductCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import UIKit
import SnapKit
import Kingfisher
import Combine

public final class ProductCell: NiblessCollectionViewCell {

    public static var standartSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width / 2 - horizontalInsets, height: 320)
    }
    public static var compactSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width / 2 - horizontalInsets, height: 285)
    }

    private static var horizontalInsets: CGFloat { horizontalPadding + horizontalPadding / 2 }
    private static let horizontalPadding: CGFloat = 20
    private var containerConstraint: Constraint?

    private var cartTapHandler: VoidClosure?
    private var cancellables = Set<AnyCancellable>()
    /// Show cell semi-transparent if product is not in favorites for favorites screen
    private var isTransparent = false
    private var isBordered = false {
        didSet {
            if isBordered {
                containerConstraint?.update(inset: 12)
                imageSlider.updateHorizontalInset(5)
                contentView.layer.borderColor = UIColor(resource: .backgroundPrimary).cgColor
                contentView.layer.cornerRadius = 12
                contentView.layer.borderWidth = 1
            } else {
                containerConstraint?.update(inset: 0)
                imageSlider.updateHorizontalInset()
                contentView.layer.cornerRadius = 0
                contentView.layer.borderWidth = 0
            }
        }
    }
    private var isCompact = true
    private let buttonAttributes = AttributeContainer([.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])

    private var isAddedToCart: Bool = false {
        didSet {
            setupConfiguration(to: cartButton)
        }
    }
    private var isFavorite: Bool = true {
        didSet {
            imageSlider.setFavoriteValue(isFavorite)
        }
    }
    private var discount: String? {
        didSet {
            discountBadge.title = discount
            discountBadge.isHidden = discount == nil
            updateSpecialsBackgroundView()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        newPriceLabel.attributedText = nil
        discountContainer.isHidden = true
        oldPriceContainer.isHidden = true
        expandableContainer.isHidden = true
        imageSlider.reset()
        cancellables.removeAll()
        cartTapHandler = nil
    }

    private lazy var containerView = UIView()
    private lazy var imageSlider = ProductImageView()
    private lazy var priceStackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()
    private lazy var newPriceLabel = UILabel()
    private lazy var oldPriceContainer = UIView()
    private lazy var oldPriceLabel = UILabel()
    private lazy var discountContainer = UIView()
    private lazy var discountBadge = DomainBadgeView(with: .init(type: .square, color: .red(opaque: false)))
    private lazy var descriptionStackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(resource: .textPrimary)
        label.numberOfLines = 3

        return label
    }()
    private lazy var expandableContainer = UIView()
    private lazy var cartButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.background.cornerRadius = 8

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(actionTapCart), for: .touchUpInside)
        setupConfiguration(to: button)

        return button
    }()

    private func setupConfiguration(to button: UIButton) {
        let newTitle = isAddedToCart ? Strings.Catalogue.inCart : Strings.Catalogue.toCart
        let backgroundColor = UIColor(resource: isAddedToCart ? .accentFaded : .accentPrimary)
        let foregroundColor = UIColor(resource: isAddedToCart ? .accentPrimary : .textWhite)
        button.configuration?.baseBackgroundColor = backgroundColor
        button.configuration?.baseForegroundColor = foregroundColor
        button.configuration?.attributedTitle = AttributedString(newTitle, attributes: buttonAttributes)
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
    }

}

public extension ProductCell {

    func configure(with model: ViewModel?) {
        #if POS
            imageSlider.favoritesContainerIsHidden = true
        #endif

        binding(favoritesPublisher: model?.favoritesPublisher)
        isCompact = (model?.cellViewType ?? .compact) == .compact
        isTransparent = model?.isTransparent ?? false
        isBordered = model?.isBordered ?? false

        imageSlider.setBadges(model?.badges)
        imageSlider.favoritesTapHandler = model?.favoritesTapHandler
        cartTapHandler = model?.cartTapHandler
        isFavorite = model?.checkedIsFavoriteClosure?() ?? false
        isAddedToCart = false

        if let newPrice = model?.newPrice {
            newPriceLabel.attributedText = newPrice

            if let oldPrice = model?.oldPrice {
                oldPriceLabel.attributedText = oldPrice
                oldPriceContainer.isHidden = false
            } else {
                oldPriceLabel.text = nil
                oldPriceLabel.attributedText = nil
                oldPriceContainer.isHidden = true
            }
        }

        discount = model?.discount
        makeTransparent(favorite: isFavorite)
        productNameLabel.text = model?.productName
        expandableContainer.isHidden = isCompact

        guard let itemImages = model?.images else {
            return
        }

        imageSlider.setImage(itemImages)
        contentView.layoutIfNeeded()
    }

    private func binding(favoritesPublisher: AnyPublisher<Bool, Never>?) {
        favoritesPublisher?
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                guard let self else {
                    return
                }

                self.imageSlider.stopLoader()
                self.imageSlider.favoriteButtonIsUserInteractionEnabled = true
                self.isFavorite = isFavorite
                self.makeTransparent(favorite: isFavorite)
            }
            .store(in: &cancellables)
    }

    private func updateSpecialsBackgroundView() {
        discountContainer.isHidden = discount == nil
    }

}

private extension ProductCell {

    @objc
    func actionTapCart() {
        cartTapHandler?()
    }

}

private extension ProductCell {

    func setupUI() {
        contentView.backgroundColor = UIColor(resource: .backgroundWhite)

        setupConstraints()
    }

    func setupConstraints() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageSlider)
        containerView.addSubview(priceStackContainer)
        containerView.addSubview(descriptionStackContainer)
        containerView.addSubview(expandableContainer)

        priceStackContainer.addArrangedSubview(oldPriceContainer)
        priceStackContainer.addArrangedSubview(newPriceLabel)
        oldPriceContainer.addSubview(oldPriceLabel)
        oldPriceContainer.addSubview(discountContainer)
        discountContainer.addSubview(discountBadge)
        descriptionStackContainer.addArrangedSubview(productNameLabel)
        expandableContainer.addSubview(cartButton)

        containerView.snp.makeConstraints { make in
            containerConstraint = make.directionalEdges.equalToSuperview().inset(0).constraint
        }
        imageSlider.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(priceStackContainer.snp.top).offset(-4)
        }
        priceStackContainer.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalTo(descriptionStackContainer.snp.top).offset(-4)
        }
        newPriceLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        oldPriceContainer.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        oldPriceLabel.snp.makeConstraints { make in
            make.leading.directionalVerticalEdges.equalToSuperview()
            make.trailing.equalTo(discountContainer.snp.leading).offset(-4)
        }
        discountContainer.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
        discountBadge.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(4)
            make.directionalVerticalEdges.equalToSuperview()
        }
        descriptionStackContainer.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualTo(expandableContainer.snp.top).offset(-8)
        }
        productNameLabel.snp.contentCompressionResistanceVerticalPriority = 751
        expandableContainer.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        cartButton.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(8)
            make.directionalVerticalEdges.equalToSuperview()
        }
    }

    func makeTransparent(favorite isFavorite: Bool) {
        contentView.alpha = isTransparent && !isFavorite ? 0.2 : 1.0
    }

}
