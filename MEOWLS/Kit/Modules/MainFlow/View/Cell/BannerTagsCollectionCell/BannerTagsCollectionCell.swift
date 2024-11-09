//
//  BannerTagsCollectionCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class BannerTagsCollectionCell: NiblessCollectionViewCell {

    private var tapClosure: VoidClosure?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        tapClosure = nil
        label.isHidden = true
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Background.backgroundWhite.color
        view.layer.borderColor = Colors.Background.backgroundSecondary.color.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 24.0
        view.layer.masksToBounds = true

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tagTapped))
        view.addGestureRecognizer(tapGR)

        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.spacing = 4.0
        stack.backgroundColor = Colors.Background.backgroundWhite.color

        return stack
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 24.0, height: 24.0))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = Colors.Background.backgroundWhite.color

        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.backgroundColor = Colors.Background.backgroundWhite.color

        return label
    }()

}

extension BannerTagsCollectionCell {

    func configure(with model: ViewModel) {
        imageView.kf.indicatorType = .activity
        imageView.fetchImage(model.url, placeholder: model.placeHolder, options: [.fade(1.0), .cache])

        tapClosure = model.tapClosure

        if let title = model.label {
            label.text = title
            label.isHidden = false
        }
    }

}

private extension BannerTagsCollectionCell {

    @objc
    func tagTapped() {
        tapClosure?()
    }

}

private extension BannerTagsCollectionCell {

    func setupUI() {
        contentView.addSubview(containerView)

        containerView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        setupConstraints()
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24.0)
            make.top.bottom.equalToSuperview().inset(12.0)
        }

        imageView.snp.makeConstraints { make in
            make.size.equalTo(24.0)
        }
    }

}
