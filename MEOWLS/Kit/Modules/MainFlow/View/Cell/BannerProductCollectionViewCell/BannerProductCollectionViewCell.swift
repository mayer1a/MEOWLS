//
//  BannerProductCollectionViewCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit
import Kingfisher
import SnapKit
import Combine

final class BannerProductCollectionViewCell: NiblessCollectionViewCell {

    private var cancellables = Set<AnyCancellable>()
    private var favoriteTapClosure: VoidClosure?

    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.accessibilityLabel = "productImageView"
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.accessibilityLabel = "favoriteImageView"
        imageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(resource: .heartButtonChecked).withRenderingMode(.alwaysTemplate)

        return imageView
    }()

    private lazy var specialPromoLabelContainer: UIView = {
        let view = UIView()
        view.accessibilityLabel = "specialPromoLabelContainer"
        view.layer.cornerRadius = 6
        view.isHidden = true
        view.backgroundColor = UIColor(resource: .badgeGreenPrimary)

        return view
    }()

    private lazy var specialPromoLabel: UILabel = {
        let label = UILabel()
        label.accessibilityLabel = "specialPromoLabel"
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .left
        label.textColor = UIColor(resource: .backgroundWhite)

        return label
    }()

    private lazy var oldPriceLabelContainer: UIView = {
        let view = UIView()
        view.accessibilityLabel = "oldPriceContainer"
        view.isHidden = true

        return view
    }()

    private lazy var oldPriceLabel: UILabel = {
        let label = UILabel()
        label.accessibilityLabel = "oldPriceLabel"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = UIColor(resource: .textSecondary)
        label.snp.contentHuggingVerticalPriority = 251
        label.snp.contentHuggingHorizontalPriority = 251
        label.snp.contentCompressionResistanceHorizontalPriority = 751

        return label
    }()

    private lazy var specialSaleContainer: UIView = {
        let view = UIView()
        view.accessibilityLabel = "specialSaleContainer"
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(resource: .accentPrimary).cgColor
        view.backgroundColor = UIColor(resource: .backgroundWhite)
        view.isHidden = true

        return view
    }()

    private lazy var specialSaleLabel: UILabel = {
        let label = UILabel()
        label.accessibilityLabel = "specialSaleLabel"
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        label.textColor = UIColor(resource: .accentPrimary)
        label.snp.contentHuggingVerticalPriority = 251
        label.snp.contentHuggingHorizontalPriority = 251

        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.accessibilityLabel = "priceLabel"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(resource: .textPrimary)
        label.textAlignment = .left

        return label
    }()

    private lazy var descriptionStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .top

        return view
    }()

    private lazy var descriptionLabelContainer = UIView()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.accessibilityLabel = "descriptionLabel"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.textColor = UIColor(resource: .textPrimary)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
        productImageView.image = nil
        favoriteImageView.tintColor = UIColor(resource: .iconDisabled)
        favoriteTapClosure = nil
        specialPromoLabelContainer.isHidden = true
        specialPromoLabel.text = nil
        oldPriceLabelContainer.isHidden = true
        oldPriceLabel.text = nil
        specialSaleContainer.isHidden = true
        specialSaleLabel.text = nil
        priceLabel.text = nil
        descriptionLabel.text = nil
    }

    @objc
    private func favoriteTapped() {
        guard let favoriteTapClosure else {
            return
        }

        favoriteImageView.isUserInteractionEnabled = false
        favoriteTapClosure()
    }

}

extension BannerProductCollectionViewCell {

    func configure(with model: ViewModel) {
        cancellables = Set<AnyCancellable>()
        productImageView.kf.indicatorType = .activity
        productImageView.fetchImage(model.productImageURL, options: [.fade(1.0), .cache])

        favoriteTapClosure = model.favoriteTapClosure

        binding(favoritesPublisher: model.favoritePublisher)

        if let isFavorite = model.checkedIsFavoriteClosure?() {
            favoriteImageView.tintColor = UIColor(resource: isFavorite ? .accentPrimary : .iconDisabled)
        }

        configureBadges(model.badges)
        configureOldPrice(model.oldPrice)
        configureSale(model.specialSale)

        priceLabel.text = model.price
        descriptionLabel.text = model.description
    }

}

private extension BannerProductCollectionViewCell {

    func configureBadges(_ badges: [Product.ProductVariant.Badge]?) {
        guard let badges else { return }

        specialPromoLabelContainer.isHidden = false
        specialPromoLabel.text = badges.first?.text

    }

    func configureOldPrice(_ oldPrice: String?) {
        guard let oldPrice else { return }

        let attributes: [NSAttributedString.Key : Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor(resource: .textSecondary)
        ]
        oldPriceLabel.attributedText = NSMutableAttributedString(string: oldPrice, attributes: attributes)
        oldPriceLabelContainer.isHidden = false
    }

    func configureSale(_ sale: String?) {
        guard let sale else { return }

        specialSaleContainer.isHidden = false
        specialSaleLabel.text = sale
    }

    func binding(favoritesPublisher: AnyPublisher<Bool, Never>?) {
        favoritesPublisher?
            .receive(on: RunLoop.main)
            .sink { [weak self] isFavorite in
                guard let self else {
                    return
                }

                self.favoriteImageView.isUserInteractionEnabled = true
                self.favoriteImageView.tintColor = UIColor(resource: isFavorite ? .accentPrimary : .iconDisabled)
            }
            .store(in: &cancellables)
    }

}

private extension BannerProductCollectionViewCell {

    func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(resource: .backgroundPrimary).cgColor

        setupConstraints()
    }

    func setupConstraints() {
        contentView.addSubview(productImageView)
        contentView.addSubview(favoriteImageView)
        contentView.addSubview(specialPromoLabelContainer)
        contentView.addSubview(oldPriceLabelContainer)
        contentView.addSubview(priceLabel)
        contentView.addSubview(descriptionStackView)

        specialPromoLabelContainer.addSubview(specialPromoLabel)
        oldPriceLabelContainer.addSubview(oldPriceLabel)
        oldPriceLabelContainer.addSubview(specialSaleContainer)
        specialSaleContainer.addSubview(specialSaleLabel)
        descriptionStackView.addArrangedSubview(descriptionLabelContainer)
        descriptionLabelContainer.addSubview(descriptionLabel)

        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(157)
        }
        favoriteImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.trailing.equalTo(productImageView)
        }
        specialPromoLabelContainer.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.leading)
            make.centerY.equalTo(favoriteImageView.snp.centerY)
        }
        specialPromoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4)
        }
        oldPriceLabelContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(productImageView)
            make.top.equalTo(productImageView.snp.bottom).offset(8)
        }
        oldPriceLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        specialSaleContainer.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualTo(oldPriceLabelContainer.snp.trailing)
            make.leading.equalTo(oldPriceLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        specialSaleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(3)
            make.top.bottom.equalToSuperview().inset(1)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(productImageView)
            make.top.equalTo(productImageView.snp.bottom).offset(30)
            make.height.equalTo(22)
        }
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
