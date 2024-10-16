//
//  DomainCartSizeSelectButton.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import UIKit

public final class DomainButton: NiblessButton {

    public enum ButtonType {
        case smallWithArrow
        case cartSizeSelect(title: String? = nil)
    }

    private let type: ButtonType
    private var font: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    private var textColor: UIColor {
        UIColor(resource: isEnabled ? .textPrimary : .textDisabled)
    }

    public init(with type: ButtonType) {
        self.type = type

        super.init(frame: .zero)

        setupView()
    }

    public override func setTitle(_ title: String?, for state: UIControl.State) {
        updateTitle(with: title)

        layoutIfNeeded()
    }

    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
        updateImage(image)

        layoutIfNeeded()
    }

    private func setupView() {
        layer.masksToBounds = true

        setupConfiguration()
    }

    private func setupConfiguration() {

        let textTransformer: UIConfigurationTextAttributesTransformer?
        let builder = DomainButtonBuilder()
            .setTextColor(textColor)
            .setBackgroundColor(UIColor(resource: .backgroundPrimary))

        switch type {
        case .smallWithArrow:
            font = .systemFont(ofSize: 13, weight: .semibold)

            textTransformer = UIConfigurationTextAttributesTransformer { [weak self] incoming in
                var outgoing = incoming
                outgoing.foregroundColor = UIColor(resource: .textPrimary)
                outgoing.font = self?.font
                return outgoing
            }

            builder
                .setTitle(titleLabel?.text)
                .setContentInsets(NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
                .setImage(UIImage(resource: .arrowRight), placement: .trailing)
                .setCornerRadius(18.0)

        case .cartSizeSelect(let title):
            contentHorizontalAlignment = .fill
            setTitle(title, for: [])
            textTransformer = nil

            builder
                .setTitle(titleLabel?.text, alignment: .leading)
                .setContentInsets(NSDirectionalEdgeInsets(top: 10.0, leading: 12.0, bottom: 10.0, trailing: 12.0))
                .setImage(UIImage(resource: .chevronDown), placement: .trailing)
                .setImageColor(UIColor(resource: .iconPrimary))
                .setBorder(color: UIColor(resource: .backgroundSecondary), width: 0.0)
                .setCornerRadius(10.0)

        }

        var configuration = builder.setFont(font).buildConfiguration()
        configuration.titleTextAttributesTransformer = textTransformer ?? configuration.titleTextAttributesTransformer

        self.configuration = configuration

        configureUpdateHandler()
    }

    private func updateTitle(with text: String?) {
        var configuration = configuration

        var title = AttributedString(text ?? "")
        title.font = font
        title.foregroundColor = textColor
        configuration?.attributedTitle = title

        self.configuration = configuration
    }

    private func updateImage(_ image: UIImage?) {
        var configuration = configuration
        configuration?.image = image

        self.configuration = configuration
    }

    private func configureUpdateHandler() {
        configurationUpdateHandler = { button in
            var textColor: UIColor?
            var backgroundColor: UIColor?
            var borderWidth: CGFloat
            var imageColor: UIColor?

            if button.isEnabled {
                textColor = UIColor(resource: .textPrimary)
                backgroundColor = UIColor(resource: .backgroundPrimary)
                borderWidth = 0.0
                imageColor = UIColor(resource: .iconPrimary)
            } else {
                textColor = UIColor(resource: .textDisabled)
                backgroundColor = UIColor(resource: .backgroundWhite)
                borderWidth = 1.0
                imageColor = UIColor(resource: .textDisabled)
            }

            var configuration = button.configuration
            configuration?.attributedTitle?.foregroundColor = textColor
            configuration?.background.backgroundColor = backgroundColor
            configuration?.background.strokeWidth = borderWidth
            configuration?.baseForegroundColor = imageColor

            button.configuration = configuration
        }
    }

}
