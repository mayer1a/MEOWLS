//
//  RegionCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import UIKit

final class RegionCell: NiblessTableViewCell {

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    private lazy var stackContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(resource: .textPrimary)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(resource: .textSecondary)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        subtitleLabel.text = nil
        subtitleLabel.isHidden = true
    }

}

extension RegionCell {

    func configure(with title: String, subtitle: String? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        if subtitle == nil {
            subtitleLabel.isHidden = true
            accessoryView = nil
        } else {
            subtitleLabel.isHidden = false

            let image = UIImage(resource: .check).withRenderingMode(.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = UIColor(resource: .accentPrimary)
            imageView.frame.size = .init(width: 20, height: 20)
            accessoryView = imageView
        }
    }

}

private extension RegionCell {

    func setupUI() {
        setupConstraints()
    }

    func setupConstraints() {
        contentView.addSubview(stackContainerView)
        stackContainerView.addArrangedSubview(titleLabel)
        stackContainerView.addArrangedSubview(subtitleLabel)

        stackContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
        }
        titleLabel.snp.contentHuggingHorizontalPriority = 250
        subtitleLabel.snp.contentHuggingHorizontalPriority = 251
        subtitleLabel.snp.contentCompressionResistanceHorizontalPriority = 752
    }

}
