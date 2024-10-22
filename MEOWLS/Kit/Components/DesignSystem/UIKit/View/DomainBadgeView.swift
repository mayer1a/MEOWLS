//
//  DomainBadgeView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 19.10.2024.
//

import UIKit
import SnapKit

public final class DomainBadgeView: NiblessView {

    public convenience init(with configuration: Configuration, frame: CGRect = .zero) {
        self.init(frame: frame)

        setupUI()
        setupConfiguration(configuration)
    }

    private override init() {
        super.init()
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public override var bounds: CGRect {
        didSet {
            setupCornerRadius()
        }
    }

    public var title: String? = "" {
        didSet {
            badgeLabel.text = title
        }
    }

    public var badgeTextColor = UIColor(resource: .backgroundWhite) {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }

    public var badgeBackgroundColor = UIColor(resource: .badgeGreenPrimary) {
        didSet {
            backgroundColor = badgeBackgroundColor
        }
    }

    public var badgeFont: UIFont = UIFont.systemFont(ofSize: 12, weight: .medium) {
        didSet {
            badgeLabel.font = badgeFont
        }
    }

    public var cornerRadiusAspect: CGFloat = 0.5 {
        didSet {
            setupCornerRadius()
        }
    }

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        return label
    }()

    private var badgeSideInsetsConstraint: Constraint?

}

private extension DomainBadgeView {

    func setupUI() {
        layer.masksToBounds = true
        badgeLabel.textColor = badgeTextColor
        badgeLabel.font = badgeFont
        backgroundColor = badgeBackgroundColor

        setupConstraints()
    }

    func setupConstraints() {
        addSubview(badgeLabel)

        badgeLabel.snp.makeConstraints { make in
            badgeSideInsetsConstraint = make.leading.trailing.equalToSuperview().inset(1.0).constraint
            make.top.bottom.equalToSuperview().inset(2.0)
        }
        badgeLabel.snp.contentHuggingHorizontalPriority = 752.0
        badgeLabel.snp.contentCompressionResistanceHorizontalPriority = 753.0
    }

    func setupConfiguration(_ configuration: Configuration) {
        cornerRadiusAspect = configuration.type.rawValue
        badgeBackgroundColor = configuration.color.rawValue.backgroundColor
        badgeTextColor = configuration.color.rawValue.textColor
        badgeFont = configuration.size.rawValue.font
        badgeSideInsetsConstraint?.update(inset: configuration.size.rawValue.sideInset)
    }

    func setupCornerRadius() {
        layer.cornerRadius = bounds.size.height * cornerRadiusAspect
    }

}

extension DomainBadgeView.Configuration.Size {

    struct SizeConfiguration {
        let sideInset: CGFloat
        let font: UIFont
    }

    var rawValue: SizeConfiguration {
        var sideInset: CGFloat
        var font: UIFont

        switch self {
        case .small:
            sideInset =  4.0
            font = UIFont.systemFont(ofSize: 12, weight: .medium)

        case .big:
            sideInset = 6.0
            font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        }

        return .init(sideInset: sideInset, font: font)
    }

}

private extension DomainBadgeView.Configuration.Color {

    struct ColorConfiguration {
        let backgroundColor: UIColor
        let textColor: UIColor
    }

    var rawValue: ColorConfiguration {
        var backgroundColor: UIColor
        var textColor: UIColor

        switch self {
        case .red(let opaque):
            backgroundColor = UIColor(resource: opaque ? .accentTertiary : .badgeRedSecondary)
            textColor = UIColor(resource: opaque ? .textWhite : .accentTertiary)

        case .green(let opaque):
            backgroundColor = UIColor(resource: opaque ? .badgeGreenPrimary : .badgeGreenSecondary)
            textColor = UIColor(resource: opaque ? .textWhite : .badgeGreenPrimary)

        case .black(let opaque):
            backgroundColor = UIColor(resource: opaque ? .backgroundDark : .backgroundSecondary)
            textColor = UIColor(resource: opaque ? .textWhite : .textSecondary)

        }

        return .init(backgroundColor: backgroundColor, textColor: textColor)
    }

}

public extension DomainBadgeView {

    struct Configuration {

        public let size: Size
        public let type: BadgeType
        public let color: Color

        public enum Size {
            case small
            case big
        }

        public enum BadgeType: CGFloat {
            case square = 0.33
            case round = 0.5
        }

        public enum Color {
            case red(opaque: Bool)
            case green(opaque: Bool)
            case black(opaque: Bool)
        }

    }

}
