//
//  AlertViewController.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import UIKit
import SnapKit

public final class AlertViewController: NiblessViewController {

    private typealias ActionButtonTuple = (action: Action, button: UIButton)

    private let titleText: String?
    private let messageText: String?
    private let messageColor: UIColor?

    private var actionsAndButtons = [ActionButtonTuple]()

    private var actions: [Action] {
        actionsAndButtons.map({ $0.action })
    }
    private var buttons: [UIButton] {
        actionsAndButtons.map({ $0.button })
    }

    private let buttonFont = UIFont.systemFont(ofSize: 14)
    private let separatorHeight: Double = 1

    public required init(title: String?, message: String?, messageColor: UIColor? = nil) {
        self.titleText = title
        self.messageText = message
        self.messageColor = messageColor

        super.init()

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        containerView.layoutIfNeeded()
        changeButtonsStackViewAxisIfNeeded()
    }

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Background.backgroundWhite.color
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var dimmedEffectView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Shadow.shadowMedium.color
        return view
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = Colors.Text.textPrimary.color
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = messageText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = messageColor ?? Colors.Text.textTertiary.color
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.Background.backgroundSecondary.color
        return view
    }()

}

// MARK: - Add action

extension AlertViewController {

    func add(_ actions: Action...) {
        add(actions)
    }

    func add(_ actions: [Action]) {
        actions.forEach { action in
            add(action: action)
        }
    }

    private func add(action: Action) {
        let button = UIButton(type: .system)
        button.setTitle(action.title, for: [])
        button.titleLabel?.font = action.style.font()
        button.tintColor = action.style.color()
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(action, action: #selector(action.callHandler), for: .touchUpInside)

        if action.style == .cancel {
            buttonsStackView.insertArrangedSubview(button, at: 0)
        } else {
            buttonsStackView.addArrangedSubview(button)
        }
        actionsAndButtons.append((action, button))
    }

}


// MARK: - Configure UI

extension AlertViewController {

    private func setupUI() {
        titleLabel.text = titleText
        messageLabel.text = messageText

        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubview(dimmedEffectView)
        view.addSubview(containerView)
        containerView.addSubview(contentStackView)
        containerView.addSubview(separatorView)
        containerView.addSubview(buttonsStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(messageLabel)

        dimmedEffectView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(25)
            make.bottom.equalTo(separatorView.snp.top).offset(-15)
        }
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(separatorHeight)
            make.bottom.equalTo(buttonsStackView.snp.top).offset(-10)
        }
        buttonsStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }

    private func changeButtonsStackViewAxisIfNeeded() {
        var isNeeded = false
        buttons.forEach { button in
            if self.isTextDoesNotFit(in: button) {
                isNeeded = true
            }
        }
        if isNeeded && buttonsStackView.axis != .vertical {
            reorderButtons()
            addVerticalSeparators()

            buttonsStackView.axis = .vertical
            buttonsStackView.spacing = 5.0
            buttonsStackView.distribution = .fill

            view.layoutIfNeeded()
        }
    }

    private func isTextDoesNotFit(in button: UIButton) -> Bool {
        guard let label = button.titleLabel, let text = button.title(for: .normal) as? NSString else {
            return false
        }

        let size = CGSize(width: .greatestFiniteMagnitude, height: label.frame.size.height)
        let attributes: [NSAttributedString.Key: Any] = [.font: button.titleLabel?.font ?? buttonFont]
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        let labelWidth = label.frame.size.width
        return rect.size.width > labelWidth
    }

    private func reorderButtons() {
        actionsAndButtons.forEach { action, button in
            if action.style == .cancel {
                buttonsStackView.removeArrangedSubview(button)
                buttonsStackView.addArrangedSubview(button)
            }

            button.titleLabel?.font = buttonFont
        }
    }

    private func addVerticalSeparators() {
        let arrangedSubviews = buttonsStackView.arrangedSubviews

        for (index, view) in arrangedSubviews.enumerated() {
            guard view is UIButton else { continue }

            if index < buttons.count - 1 {
                let separator = UIView()
                // To ensure that indexing remains correct, multiply by 2 (for buttons and separators).
                buttonsStackView.insertArrangedSubview(separator, at: index * 2 + 1)

                separator.snp.makeConstraints { make in
                    make.height.equalTo(separatorHeight)
                }
                separator.backgroundColor = Colors.Background.backgroundLight.color
            }
        }
    }

}

// MARK: - View action

extension AlertViewController {

    @objc
    private func buttonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
