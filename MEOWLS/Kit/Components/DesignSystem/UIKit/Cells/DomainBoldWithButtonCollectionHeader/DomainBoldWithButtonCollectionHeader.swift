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

    private lazy var containerView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .backgroundWhite)

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
        let button = UIButton(type: .system)
        button.setTitle("more", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(resource: .accentPrimary), for: .normal)
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)

        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstraints()
    }

    @objc private func buttonTap() {
        buttonTapHandler?()
    }

}

public extension DomainBoldWithButtonCollectionHeader {

    func configure(with model: ViewModel) {
        self.titleLabel.text = model.title
        self.moreButton.setTitle(model.buttonTitle, for: .normal)
        self.moreButton.isHidden = model.buttonTitle == nil
        self.buttonTapHandler = model.buttonTapHandler
    }


}

private extension DomainBoldWithButtonCollectionHeader {

    func setupUI() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(moreButton)
        containerView.addSubview(stackView)

        addSubview(containerView)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
            make.top.greaterThanOrEqualToSuperview().offset(10)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
        }

        moreButton.snp.makeConstraints { make in
            make.height.equalTo(28)
            make.width.equalTo(107)
        }
    }

}
