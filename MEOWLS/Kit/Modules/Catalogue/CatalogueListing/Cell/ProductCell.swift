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
import ImageSlideshow

public final class ProductCell: NiblessCollectionViewCell {

    public static var standartSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width / 2 - horizontalInsets, height: 315)
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
                containerConstraint?.update(inset: 16)
                imageSlider.updateHorizontalInset(0)
                contentView.layer.borderColor = UIColor(resource: .backgroundPrimary).cgColor
                contentView.layer.cornerRadius = 12
                contentView.layer.borderWidth = 1
            } else {
                containerConstraint?.update(inset: 0)
                imageSlider.updateHorizontalInset(10)
                contentView.layer.cornerRadius = 0
                contentView.layer.borderWidth = 0
            }
        }
    }
    private var isCompact = true

    private var isAddedToCart: Bool = false {
        didSet {
            let backgroundColor = UIColor(resource: isAddedToCart ? .accentFaded : .accentPrimary)
            cartButton.configuration?.baseBackgroundColor = backgroundColor
            cartButton.configuration?.image = UIImage(resource: isAddedToCart ? .check : .checkCircle)
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
        imageSlider.reset()
    }

    private lazy var containerView = UIView()
    private lazy var imageSlider = ProductImageSlider()
    private lazy var priceStackContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()
    private lazy var newPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(resource: .textPrimary)
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    private lazy var oldPriceContainer = UIView()
    private lazy var oldPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(resource: .textPrimary)
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    private lazy var discountContainer = UIView()
    private lazy var discountBadge: DomainBadgeView = {
        DomainBadgeView(with: .init(size: .small, type: .square, color: .red(opaque: false)))
    }()
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
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    private lazy var expandableContainer: UIView = {
        let view = UIView()
        view.isHidden = true

        return view
    }()
    private lazy var cartButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(resource: .checkCircle).withRenderingMode(.alwaysTemplate)
        configuration.baseBackgroundColor =  UIColor(resource: .accentPrimary)
        configuration.baseForegroundColor = UIColor(resource: .iconDisabled)
        configuration.contentInsets = .init(top: 5, leading: 0, bottom: 5, trailing: 0)
        configuration.background.cornerRadius = 8

        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(actionTapCart), for: .touchUpInside)

        return button
    }()

}

public extension ProductCell {

    func configure(with model: ProductCell.ViewModel?) {
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
        let placeholder = UIImage(resource: .itemLong)
        let edge = (isCompact ? Self.compactSize.width : Self.standartSize.width) * UIScreen.main.scale

        let sourceImages: [InputSource]
        if itemImages.isEmpty {
            sourceImages = [ImageSource(image: placeholder)]
        } else {
            sourceImages = itemImages.compactMap {
                KingfisherSource(urlString: $0.scale(factor: .pixels(edge)).url ?? "",
                                 placeholder: placeholder,
                                 options: .cachedFadedOptions(with: placeholder))
            }
        }

        imageSlider.setImageInputs(sourceImages)
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

public extension ProductCell {

    func toSleep() {
        imageSlider.toSleep()
    }

    func dismiss() {
        imageSlider.closeView()
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
            containerConstraint = make.edges.equalToSuperview().inset(0).constraint
        }
        imageSlider.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(priceStackContainer.snp.top).offset(-4)
        }
        priceStackContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(descriptionStackContainer.snp.top).offset(-4)
        }
        newPriceLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        oldPriceContainer.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        oldPriceLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.trailing.equalTo(discountContainer.snp.leading).offset(-4)
        }
        discountContainer.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
        }
        discountBadge.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(4)
            make.verticalEdges.equalToSuperview().inset(2)
        }
        descriptionStackContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualTo(expandableContainer.snp.top).offset(-5)
        }
        productNameLabel.snp.contentCompressionResistanceVerticalPriority = 751
        expandableContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        cartButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(5)
            make.verticalEdges.equalToSuperview()
        }
    }

    func makeTransparent(favorite isFavorite: Bool) {
        contentView.alpha = isTransparent && !isFavorite ? 0.2 : 1.0
    }

}
