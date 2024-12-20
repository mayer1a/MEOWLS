//
//  DomainBoldWithButtonCollectionHeader.swift
//  MEOWLS
//
//  Created by Artem Mayer on 17.10.2024.
//

import UIKit
import SnapKit

public final class DomainBoldWithButtonCollectionHeader: NiblessCollectionReusableView {

    public static let prefferedHeight: CGFloat = 52

    private var buttonTapHandler: VoidClosure?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    private lazy var containerView = {
        let view = UIView()
        view.backgroundColor = Colors.Background.backgroundWhite.color

        return view
    }()
    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.distribution = .equalSpacing

        return stackView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.minimumScaleFactor = 0.9
        label.lineBreakMode = .byTruncatingTail

        return label
    }()
    private lazy var moreButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.configuration?.baseForegroundColor = Colors.Icon.iconPrimary.color
        button.configuration?.baseBackgroundColor = Colors.Background.backgroundPrimary.color
        button.configuration?.image = Images.Common.arrowRight.image.withRenderingMode(.alwaysTemplate)
        button.configuration?.imagePadding = 10
        button.configuration?.imagePlacement = .trailing
        button.configuration?.contentInsets = .init(top: 20, leading: 10, bottom: 20, trailing: 10)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.configuration?.background.cornerRadius = 15

        return button
    }()

}

public extension DomainBoldWithButtonCollectionHeader {

    func configure(with model: ViewModel) {
        titleLabel.text = model.title
        moreButton.configuration?.attributedTitle = model.buttonTitle
        moreButton.isHidden = model.buttonTitle == nil
        buttonTapHandler = model.buttonTapHandler
    }

}

private extension DomainBoldWithButtonCollectionHeader {

    @objc
    private func buttonTap() {
        buttonTapHandler?()
    }

}

private extension DomainBoldWithButtonCollectionHeader {

    func setupUI() {
        setupConstraints()
    }

    func setupConstraints() {
        addSubview(containerView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(moreButton)
        containerView.addSubview(stackView)

        containerView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
            make.top.greaterThanOrEqualToSuperview().offset(10)
        }
    }

}
