//
//  BannerCollectionViewCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit
import Kingfisher
import SnapKit

final class BannerCollectionViewCell: NiblessCollectionViewCell {

    private var imageTappedClosure: VoidClosure?

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8

        return stack
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.isHidden = false
        label.text = " "

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        imageTappedClosure = nil
        label.isHidden = true
    }

    override func setup() {
        super.setup()

        setupUI()
    }

    @objc
    private func imageTapped() {
        imageTappedClosure?()
    }

}

extension BannerCollectionViewCell {

    func configure(with model: ViewModel) {
        imageView.kf.indicatorType = .activity
        imageView.fetchImage(model.url, placeholder: model.placeHolder, options: [.fade(1.0), .cache])
        imageTappedClosure = model.tapClosure
        if let title = model.label, !title.isEmpty {
            label.text = title
            label.isHidden = false
        }
        else {
            label.text = " "
            label.isHidden = true
        }
    }

}

private extension BannerCollectionViewCell {

    func setupUI() {
        setupConstraints()
    }

    func setupConstraints() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
    }

}
