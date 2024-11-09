//
//  BadgeConfiguration.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.10.2024.
//

import UIKit

public struct BadgeConfiguration {

    public let size: Size
    public let type: BadgeType
    public let color: Color

    public init(size: Size = .small, type: BadgeType = .round, color: Color) {
        self.size = size
        self.type = type
        self.color = color
    }

    public enum Size {
        case small
        case big
    }

    public enum BadgeType: CGFloat {
        case square = 0.33
        case round = 0.5
    }

    public enum Color {
        case red(opaque: Bool = true)
        case green(opaque: Bool = true)
        case black(opaque: Bool = true)
    }

}

public extension BadgeConfiguration.Size {

    var font: UIFont {
        var font: UIFont

        switch self {
        case .small:
            font = UIFont.systemFont(ofSize: 12, weight: .medium)

        case .big:
            font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        }

        return font
    }

    var horizontalPadding: CGFloat {
        self == .small ? 4.0 : 6.0
    }

    var textHeight: CGFloat {
        self == .small ? 16 : 20
    }

}

public extension BadgeConfiguration.Color {

    var backgroundColor: UIColor {
        var backgroundColor: UIColor

        switch self {
        case .red(let opaque):
            backgroundColor = opaque ? Colors.Accent.accentTertiary.color : Colors.Badge.badgeRedSecondary.color

        case .green(let opaque):
            backgroundColor = opaque ? Colors.Badge.badgeGreenPrimary.color : Colors.Badge.badgeGreenSecondary.color

        case .black(let opaque):
            backgroundColor = (opaque ? Colors.Background.backgroundDark : Colors.Background.backgroundSecondary).color

        }

        return backgroundColor
    }

    var foregroundColor: UIColor {
        var textColor: UIColor

        switch self {
        case .red(let opaque):
            textColor = opaque ? Colors.Text.textWhite.color : Colors.Accent.accentTertiary.color

        case .green(let opaque):
            textColor = opaque ? Colors.Text.textWhite.color : Colors.Badge.badgeGreenPrimary.color

        case .black(let opaque):
            textColor = opaque ? Colors.Text.textWhite.color : Colors.Text.textSecondary.color

        }

        return textColor
    }

}
