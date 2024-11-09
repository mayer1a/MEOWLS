//
//  DomainBadgeView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 19.10.2024.
//

import UIKit
import SnapKit

public final class DomainBadgeView: NiblessControl {

    public convenience init(with configuration: BadgeConfiguration, frame: CGRect = .zero) {
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

    public var badgeTextColor = Colors.Background.backgroundWhite.color {
        didSet {
            badgeLabel.textColor = badgeTextColor
        }
    }

    public var badgeBackgroundColor = Colors.Badge.badgeGreenPrimary.color {
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

    func setupConfiguration(_ configuration: BadgeConfiguration) {
        cornerRadiusAspect = configuration.type.rawValue
        badgeBackgroundColor = configuration.color.backgroundColor
        badgeTextColor = configuration.color.foregroundColor
        badgeFont = configuration.size.font
        badgeSideInsetsConstraint?.update(inset: configuration.size.horizontalPadding)
    }

    func setupCornerRadius() {
        layer.cornerRadius = bounds.size.height * cornerRadiusAspect
    }

}
