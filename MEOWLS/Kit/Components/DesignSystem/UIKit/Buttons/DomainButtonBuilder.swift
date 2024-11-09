//
//  DomainButtonBuilder.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import UIKit

public final class DomainButtonBuilder {

    private var title: String?
    private var titleAlignment: UIButton.Configuration.TitleAlignment?
    private var font: UIFont?
    private var image: UIImage?
    private var imagePadding: CGFloat?
    private var imagePlacement: NSDirectionalRectEdge?
    private var textColor: UIColor?
    private var backgroundColor: UIColor?
    private var imageColor: UIColor?
    private var borderColor: UIColor?
    private var cornerRadius: CGFloat?
    private var borderWidth: CGFloat?
    private var contentInsets: NSDirectionalEdgeInsets?

    @discardableResult
    public func setTitle(_ title: String?, alignment: UIButton.Configuration.TitleAlignment? = nil) -> Self {
        self.title = title
        self.titleAlignment = alignment
        return self
    }

    @discardableResult
    public func setFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    public func setImage(_ image: UIImage?, placement: NSDirectionalRectEdge? = nil) -> Self {
        self.image = image
        self.imagePlacement = placement
        return self
    }

    @discardableResult
    public func setImagePadding(_ padding: CGFloat) -> Self {
        self.imagePadding = padding
        return self
    }

    @discardableResult
    public func setTextColor(_ textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }

    @discardableResult
    public func setBackgroundColor(_ backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }

    @discardableResult
    public func setImageColor(_ imageColor: UIColor?) -> Self {
        self.imageColor = imageColor
        return self
    }

    @discardableResult
    public func setBorder(color: UIColor? = nil, width: CGFloat? = nil) -> Self {
        self.borderColor = color
        self.borderWidth = width
        return self
    }

    @discardableResult
    public func setCornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = cornerRadius
        return self
    }

    @discardableResult
    public func setContentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        self.contentInsets = contentInsets
        return self
    }

    public func build() -> UIButton {
        let button = configureButton()
        button.layer.masksToBounds = true

        return button
    }

    public func buildConfiguration() -> UIButton.Configuration {
        makeConfiguration()
    }

}

private extension DomainButtonBuilder {

    func configureButton() -> UIButton {
        let button = UIButton()
        button.configuration = makeConfiguration()
        button.configurationUpdateHandler = configureUpdateHandler()

        return button
    }

    func makeConfiguration() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        applyBasicStyles(configuration: &configuration)
        applyImageConfiguration(configuration: &configuration)
        applyTitleConfiguration(configuration: &configuration)

        return configuration
    }

    func applyBasicStyles(configuration: inout UIButton.Configuration) {
        configuration.baseBackgroundColor = backgroundColor ?? Colors.Background.backgroundWhite.color
        configuration.background.cornerRadius = cornerRadius ?? .zero
        configuration.background.strokeColor = borderColor
        configuration.background.strokeWidth = borderWidth ?? .zero
        configuration.contentInsets = contentInsets ?? configuration.contentInsets
    }

    func applyImageConfiguration(configuration: inout UIButton.Configuration) {
        if let imageColor {
            configuration.image = image?.withRenderingMode(.alwaysTemplate)
            configuration.baseForegroundColor = imageColor
        } else {
            configuration.image = image
        }
        configuration.imagePadding = imagePadding ?? 8.0
        configuration.imagePlacement = imagePlacement ?? configuration.imagePlacement
    }

    func applyTitleConfiguration(configuration: inout UIButton.Configuration) {
        var title = AttributedString(title ?? "")
        title.font = font ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        title.foregroundColor = textColor
        configuration.attributedTitle = title
        configuration.titleAlignment = titleAlignment ?? configuration.titleAlignment
    }

    func configureUpdateHandler() -> UIButton.ConfigurationUpdateHandler? {
        let updateHandler: (UIButton) -> Void = { button in
            var configuration = button.configuration
            if button.isEnabled {
                configuration?.attributedTitle?.foregroundColor = self.textColor
                configuration?.baseBackgroundColor = self.backgroundColor
                configuration?.background.strokeColor = self.borderColor
                configuration?.baseForegroundColor = self.imageColor
            } else {
                let isBordered = configuration?.background.strokeWidth == .zero
                let textColor = isBordered ? Colors.Text.textDisabled.color : Colors.Text.textWhite.color
                configuration?.attributedTitle?.foregroundColor = textColor
                let baseBackground = isBordered ? Colors.Background.backgroundPrimary : Colors.Text.textDisabled
                configuration?.baseBackgroundColor = baseBackground.color
                configuration?.background.strokeColor = Colors.Background.backgroundSecondary.color
                let baseForeground = isBordered ? Colors.Text.textDisabled.color : Colors.Text.textWhite.color
                configuration?.baseForegroundColor = baseForeground
            }

            button.configuration = configuration
        }

        return updateHandler
    }

}
