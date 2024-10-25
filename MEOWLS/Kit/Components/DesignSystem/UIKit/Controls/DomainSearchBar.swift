//
//  DomainSearchBar.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import UIKit
import SnapKit
import Combine

public final class DomainSearchBar: NiblessControl {

    private var shadowDidConfigure = false
    private var cancellables = Set<AnyCancellable>()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    public override init() {
        super.init()

        setupUI()
    }

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4

        return view
    }()

    private let searchFieldBackgoundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .backgroundPrimary)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var searchFieldStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 6
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTap))
        view.addGestureRecognizer(tapGesture)

        return view
    }()

    private lazy var loupeImageContainer = UIView()
    private lazy var loupeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .search).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(resource: .iconSecondary)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.tintColor = UIColor(resource: .accentPrimary)
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor(resource: .textPrimary)
        textField.clearButtonMode = .always
        textField.isUserInteractionEnabled = false
        textField.delegate = self

        return textField
    }()

    private lazy var cancelButtonContainer = UIView()
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor(resource: .accentPrimary), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)

        return button
    }()
    private var cancelButtonConstraint: Constraint?
    private var textFielTapHandler: VoidClosure?
    private var cancelHandler: VoidClosure?

}

public extension DomainSearchBar {

    func configure(with model: ViewModel) {
        let title = model.placeHolder ?? ""
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(resource: .textSecondary),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: title, attributes: attributes)

        switch model.state {
        case .initial(let model):
            textFielTapHandler = model.tapHandler
            cancelButtonContainer.isHidden = true

        case .searching(let model):
            searchFieldStackView.gestureRecognizers?.removeAll()
            textField.isUserInteractionEnabled = true
            cancelHandler = model.cancelHandler
            cancelButton.setTitle(model.cancelTitle, for: [])

            if let subject = model.textFieldSubject {
                textField.becomeFirstResponder()

                textField.textPublisher
                    .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .removeDuplicates()
                    .sink(receiveValue: { subject.send($0) })
                    .store(in: &cancellables)
            }

            animateCancelButton()

        }
    }

    func configureShadow(needDisplay: Bool) {
        if (needDisplay && layer.shadowOpacity == .zero) || (!needDisplay && layer.shadowOpacity == 1.0) {
            setupShadow(needDisplay: needDisplay)
        }
    }

}

private extension DomainSearchBar {

    @objc
    private func textFieldTap() {
        textFielTapHandler?()
    }

    @objc
    private func cancelButtonTap() {
        animateCancelButton(isShow: false)
        cancelHandler?()
    }

}

private extension DomainSearchBar {

    func setupUI() {
        backgroundColor = UIColor(resource: .backgroundWhite)
        
        setupConstraints()
    }

    func setupConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(searchFieldBackgoundView)
        searchFieldBackgoundView.addSubview(searchFieldStackView)
        searchFieldStackView.addArrangedSubview(loupeImageContainer)
        loupeImageContainer.addSubview(loupeImageView)
        searchFieldStackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(cancelButtonContainer)
        cancelButtonContainer.addSubview(cancelButton)

        self.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        stackView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.directionalVerticalEdges.equalToSuperview().inset(12)
        }
        searchFieldStackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(8)
        }
        loupeImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            cancelButtonConstraint = make.trailing.equalToSuperview().offset(100).constraint
            make.directionalVerticalEdges.equalToSuperview().inset(10)
        }
        cancelButton.snp.contentHuggingHorizontalPriority = 999
        cancelButton.snp.contentCompressionResistanceHorizontalPriority = 999
    }

    func animateCancelButton(isShow: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + (isShow ? 0.1 : 0)) { [weak self] in
            self?.cancelButtonContainer.isHidden = false
            self?.cancelButtonConstraint?.update(offset: isShow ? 0 : 100)

            UIView.animate(withDuration: 0.33) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }

    func setupShadow(needDisplay: Bool) {
        if !shadowDidConfigure {
            layer.masksToBounds = false
            layer.shadowOffset = .init(width: 0.0, height: 2.0)
            layer.shadowRadius = 12.0
            layer.shadowColor = UIColor(resource: .shadowSmall).cgColor

            let shadowY = bounds.maxY - layer.shadowRadius
            let shadowRect = CGRect(x: 0, y: shadowY, width: bounds.width, height: layer.shadowRadius)
            layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath

            shadowDidConfigure = true
        }

        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = layer.shadowOpacity
        animation.toValue = needDisplay ? 1.0 : 0.0
        animation.duration = 0.15
        layer.add(animation, forKey: animation.keyPath)
        layer.shadowOpacity = needDisplay ? 1.0 : 0.0
    }

}

extension DomainSearchBar: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
