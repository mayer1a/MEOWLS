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

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .backgroundWhite)
        view.layer.borderColor = UIColor(resource: .backgroundSecondary).cgColor
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
        stack.backgroundColor = UIColor(resource: .backgroundWhite)

        return stack
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 24.0, height: 24.0))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(resource: .backgroundWhite)

        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.backgroundColor = UIColor(resource: .backgroundWhite)

        return label
    }()

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

    @objc
    private func tagTapped() {
        tapClosure?()
    }

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

    func setupUI() {
        contentView.addSubview(containerView)

        containerView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        setupConstraints()
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
