//
//  DomainHeaderWithButtonTableCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import UIKit
import SnapKit

public final class DomainHeaderWithButtonTableCell: NiblessTableViewCell {

    private var tapButtonClosure: VoidClosure?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupUI()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        tapButtonClosure = nil
        button.isHidden = true
        button.setTitle(nil, for: [])
        titleLabel.text = ""
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5

        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.Text.textPrimary.color
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.textAlignment = .left

        return label
    }()

    private lazy var button: UIButton = {
        let button = DomainButtonFactory.makeRoundedButton()
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.isHidden = true

        return button
    }()

    private var topConst: Constraint?
    private var trailConst: Constraint?
    private var bottomConst: Constraint?
    private var leadConst: Constraint?

    @objc
    private func buttonTap() {
        tapButtonClosure?()
    }

}

public extension DomainHeaderWithButtonTableCell {

    func configureWith(_ model: ViewModel) {
        titleLabel.text = model.title

        if let buttonModel = model.buttonModel {
            button.isHidden = false
            tapButtonClosure = buttonModel.tapHandler
            button.setTitle(buttonModel.title, for: [])
        }

        if let edge = model.edge {
            topConst?.update(inset: edge.top)
            trailConst?.update(inset: edge.right)
            bottomConst?.update(inset: edge.bottom)
            leadConst?.update(inset: edge.left)

            layoutIfNeeded()
        }
    }

}

private extension DomainHeaderWithButtonTableCell {

    func setupUI() {
        selectionStyle = .none

        contentView.addSubview(stackView)
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(button)

        stackView.snp.makeConstraints { make in
            topConst = make.top.equalToSuperview().inset(16).constraint
            trailConst = make.trailing.equalToSuperview().inset(16).constraint
            bottomConst = make.bottom.equalToSuperview().inset(16).priority(999).constraint
            leadConst = make.leading.equalToSuperview().inset(16).constraint
        }
    }

}
