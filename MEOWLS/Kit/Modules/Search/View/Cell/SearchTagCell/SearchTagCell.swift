//
//  SearchTagCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import UIKit

final class SearchTagCell: NiblessCollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
        valueLabel.isHidden = true
    }

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .center

        return stackView
    }()
    private lazy var titleContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2

        return stackView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(resource: .textPrimary)
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(resource: .textSecondary)
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(resource: .textTertiary)
        label.lineBreakMode = .byTruncatingTail

        return label
    }()

}

extension SearchTagCell {

    func configure(with model: ViewModel) {
        titleLabel.attributedText = model.title
        titleLabel.isHidden = (model.title?.string).isNilOrEmpty == true

        subtitleLabel.attributedText = model.subtitle
        subtitleLabel.isHidden = (model.subtitle?.string).isNilOrEmpty == true

        valueLabel.text = model.value
        valueLabel.isHidden = model.value?.isEmpty == true
    }

}

private extension SearchTagCell {

    func setupUI() {
        contentView.backgroundColor = UIColor(resource: .backgroundPrimary)
        contentView.layer.cornerRadius = 13
        contentView.layer.masksToBounds = true

        setupConstraints()
    }

    func setupConstraints() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleContainerStackView)
        titleContainerStackView.addArrangedSubview(titleLabel)
        titleContainerStackView.addArrangedSubview(subtitleLabel)
        contentStackView.addArrangedSubview(valueLabel)

        contentStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(5)
            make.bottom.greaterThanOrEqualToSuperview().inset(5)
        }
        valueLabel.snp.contentHuggingHorizontalPriority = 252
    }

}
