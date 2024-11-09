//
//  DomainButtonFactory.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import UIKit

public struct DomainButtonFactory {

    /// Filled rounded with accent background and 14 medium white font title
    public static func makeStandardTitleButton(title: String? = nil) -> UIButton {
        let buttonBuilder = DomainButtonBuilder()
            .setFont(.systemFont(ofSize: 14, weight: .medium))
            .setTitle(title)
            .setBackgroundColor(Colors.Accent.accentPrimary.color)
            .setTextColor(Colors.Text.textWhite.color)
            .setCornerRadius(8.0)

        return buttonBuilder.build()
    }

    /// Bordered rounded accent color, white background and 14 medium accent font title
    public static func makeStandardTitleBorderButton(title: String? = nil) -> UIButton {
        let buttonBuilder = DomainButtonBuilder()
            .setFont(.systemFont(ofSize: 14, weight: .medium))
            .setTitle(title)
            .setBackgroundColor(Colors.Background.backgroundWhite.color)
            .setTextColor(Colors.Accent.accentPrimary.color)
            .setCornerRadius(8.0)
            .setBorder(color: Colors.Accent.accentPrimary.color, width: 2.0)

        return buttonBuilder.build()
    }

    /// Bordered rounded accent color, white background and image, image color from parameters
    public static func makeStandardImageBorderButton(image: UIImage?, imageColor: UIColor? = nil) -> UIButton {
        let buttonBuilder = DomainButtonBuilder()
            .setImage(image)
            .setImageColor(imageColor ?? Colors.Accent.accentPrimary.color)
            .setBackgroundColor(Colors.Background.backgroundWhite.color)
            .setCornerRadius(8.0)
            .setBorder(color: Colors.Accent.accentPrimary.color, width: 2.0)

        return buttonBuilder.build()
    }

    /// Filled rounded button
    public static func makeLargeTitleButton(title: String? = nil,
                                            font: UIFont? = nil,
                                            color: UIColor? = nil,
                                            textColor: UIColor? = nil,
                                            radius: CGFloat = 8.0,
                                            image: UIImage? = nil,
                                            imageColor: UIColor? = nil) -> UIButton {

        let buttonBuilder = DomainButtonBuilder()
            .setFont(font ?? .systemFont(ofSize: 16, weight: .semibold))
            .setTitle(title)
            .setImage(image)
            .setImageColor(imageColor)
            .setBackgroundColor(color ?? Colors.Accent.accentPrimary.color)
            .setCornerRadius(8.0)

        if textColor == nil {
            if color == Colors.Accent.accentFaded.color || color == Colors.Background.backgroundWhite.color {
                buttonBuilder.setTextColor(Colors.Accent.accentPrimary.color)
            } else {
                buttonBuilder.setTextColor(Colors.Text.textWhite.color)
            }
        }

        return buttonBuilder.build()
    }

    /// Bordered rounded with primary background, text tertiary 16 semibold font
    public static func makeLargeTitleBorderDisabledButton(title: String? = nil) -> UIButton {
        let buttonBuilder = DomainButtonBuilder()
            .setFont(.systemFont(ofSize: 16, weight: .semibold))
            .setTitle(title)
            .setTextColor(Colors.Text.textTertiary.color)
            .setBackgroundColor(Colors.Background.backgroundPrimary.color)
            .setBorder(color: Colors.Background.backgroundSecondary.color, width: 2.0)
            .setCornerRadius(8.0)

        return buttonBuilder.build()
    }

    /// Thin bordered rounded with white background and tertiary text 16 regular font
    public static func makeThinBorder(title: String? = nil, font: UIFont? = nil, color: UIColor? = nil) -> UIButton {
        let buttonBuilder = DomainButtonBuilder()
            .setFont(.systemFont(ofSize: 16))
            .setTitle(title)
            .setTextColor(color ?? Colors.Accent.accentPrimary.color)
            .setBackgroundColor(Colors.Background.backgroundWhite.color)
            .setBorder(color: color ?? Colors.Accent.accentPrimary.color, width: 2.0)
            .setCornerRadius(8.0)

        return buttonBuilder.build()
    }

    /// Plain colored image 24x24 button with 12 px image padding
    public static func makeImageColoredButton(image: UIImage?, tintColor: UIColor, tapColor: UIColor) -> UIButton {
        makeNewImageColoredButton(image: image, tintColor: tintColor, tapColor: tapColor)
    }

    /// Plain colored image 24x24 button with 12 px image padding
    public static func makeCartSizeSelectButton(title: String? = nil) -> UIButton {
        DomainButton(with: .cartSizeSelect(title: title))
    }

    public static func makeRoundedButton() -> UIButton {
        DomainButton(with: .smallWithArrow)
    }

}

private extension DomainButtonFactory {

    static func makeNewImageColoredButton(image: UIImage?, tintColor: UIColor, tapColor: UIColor) -> UIButton {
        let button = UIButton(frame: .init(x: 0, y: 0, width: 24, height: 24))
        var configuration = button.configuration ?? .plain()
        configuration.imagePadding = 12.0
        configuration.background.backgroundColor = .clear
        configuration.baseForegroundColor = tintColor
        configuration.image = image?.withRenderingMode(.alwaysTemplate)

        button.configurationUpdateHandler = { button in
            var configuration = button.configuration

            if button.isEnabled {
                let color = button.isSelected ? tapColor : tintColor
                configuration?.baseForegroundColor = color
            } else {
                configuration?.baseForegroundColor = tapColor
            }

            button.configuration = configuration
        }

        button.configuration = configuration

        return button
    }

}

