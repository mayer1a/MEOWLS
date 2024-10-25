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
            backgroundColor = UIColor(resource: opaque ? .accentTertiary : .badgeRedSecondary)

        case .green(let opaque):
            backgroundColor = UIColor(resource: opaque ? .badgeGreenPrimary : .badgeGreenSecondary)

        case .black(let opaque):
            backgroundColor = UIColor(resource: opaque ? .backgroundDark : .backgroundSecondary)

        }

        return backgroundColor
    }

    var foregroundColor: UIColor {
        var textColor: UIColor

        switch self {
        case .red(let opaque):
            textColor = UIColor(resource: opaque ? .textWhite : .accentTertiary)

        case .green(let opaque):
            textColor = UIColor(resource: opaque ? .textWhite : .badgeGreenPrimary)

        case .black(let opaque):
            textColor = UIColor(resource: opaque ? .textWhite : .textSecondary)

        }

        return textColor
    }

}
