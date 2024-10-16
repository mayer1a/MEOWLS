//
//  DomainSearchBar.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import UIKit
import SnapKit
import Combine

public final class DomainSearchBar: NiblessView {

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
        view.axis = .horizontal
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
        view.axis = .horizontal
        view.spacing = 6
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var loupeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .search).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(resource: .iconSecondary)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var textField: UITextField = {
        let view = UITextField()
        view.tintColor = UIColor(resource: .accentPrimary)
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = UIColor(resource: .textPrimary)
        view.clearButtonMode = .always
        return view
    }()

    private lazy var cancelButtonContainer = UIView()
    private lazy var cancelButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.setTitleColor(UIColor(resource: .accentPrimary), for: .normal)
        view.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
        view.snp.contentHuggingHorizontalPriority = 999
        view.snp.contentCompressionResistanceHorizontalPriority = 999
        return view
    }()

    private var textFielTapHandler: VoidClosure?
    private var cancelHandler: VoidClosure?

    @objc
    private func textFieldTap() {
        textFielTapHandler?()
    }

    @objc
    private func cancelButtonTap() {
        cancelHandler?()
    }

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
            let gr = UITapGestureRecognizer(target: self, action: #selector(textFieldTap))
            searchFieldStackView.addGestureRecognizer(gr)
            textField.isUserInteractionEnabled = false
            textFielTapHandler = model.tapHandler
            cancelButtonContainer.isHidden = true

        case .searching(let model):
            cancelHandler = model.cancelHandler
            cancelButton.setTitle(model.cancelTitle, for: [])
            if let subject = model.textFieldSubject {
                textField.publisher(for: \.text)
                    .compactMap { $0 }
                    .throttle(for: .seconds(2), scheduler: RunLoop.main, latest: true)
                    .removeDuplicates()
                    .sink(receiveValue: { subject.send($0) })
                    .store(in: &cancellables)

                textField.becomeFirstResponder()
            }
        }
    }

    func configureShadow(needDisplay: Bool) {
        if (needDisplay && layer.shadowOpacity == .zero) || (!needDisplay && layer.shadowOpacity == 1.0) {
            setupShadow(needDisplay: needDisplay)
        }
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
        searchFieldStackView.addArrangedSubview(loupeImageView)
        searchFieldStackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(cancelButtonContainer)
        cancelButtonContainer.addSubview(cancelButton)

        self.snp.makeConstraints { make in
            make.height.equalTo(64)
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
        }

        searchFieldStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        loupeImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }

        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
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
