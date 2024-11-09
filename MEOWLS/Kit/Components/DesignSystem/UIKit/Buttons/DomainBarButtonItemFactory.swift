//
//  DomainBarButtonItemFactory.swift
//  MEOWLS
//
//  Created by Artem Mayer on 28.09.2024.
//

import UIKit

public final class DomainBarButtonItemFactory {

    private var target: Any? = nil
    private var action: Selector? = nil
    private var image: UIImage? = nil
    private var size: CGSize? = nil
    private var tintColor: UIColor? = nil
    private var menuItems: [UIMenuElement]? = nil
    private var title: String? = nil

    private lazy var attributes: [NSAttributedString.Key: Any] = {
        [.font: UIFont.systemFont(ofSize: 20, weight: .medium), .foregroundColor: Colors.Text.textPrimary.color]
    }()
    private lazy var forFittingSize: CGSize = {
        CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }()

    @discardableResult
    public func setupAction(_ target: Any?, _ action: Selector?) -> Self {
        guard target != nil && action != nil || target == nil && action == nil else {
            fatalError("If need action, target and action both required")
        }
        self.target = target
        self.action = action
        return self
    }

    @discardableResult
    public func setupImage(_ image: UIImage) -> Self {
        self.image = image
        return self
    }

    @discardableResult
    public func setupTitle(_ title: String) -> Self {
        self.title = title
        return self
    }

    @discardableResult
    public func setupSize(_ size: CGSize) -> Self {
        self.size = size
        return self
    }

    @discardableResult
    public func setupTintColor(_ tintColor: UIColor) -> Self {
        self.tintColor = tintColor
        return self
    }

    @discardableResult
    public func setupMenuItems(_ menuItems: [UIMenuElement]) -> Self {
        self.menuItems = menuItems
        return self
    }

    public func make() -> UIBarButtonItem {
        guard image != nil || title != nil else {
            fatalError("UIImage and/or Title required")
        }

        let button = UIButton(type: .system)
        button.tintColor = tintColor
        button.setImage(image, for: .normal)

        if let action {
            button.addTarget(target, action: action, for: .touchUpInside)
        } else if let menuItems {
            button.showsMenuAsPrimaryAction = true
            button.menu = UIMenu(options: .displayInline, children: menuItems)
        }

        if let title {
            button.configuration = makeButtonConfig(with: image, tintColor: tintColor, title: title)
        }

        let item = UIBarButtonItem(customView: button)

        if let size {
            item.customView?.snp.makeConstraints { make in
                make.size.equalTo(size)
            }
        } else if title != nil {
            let buttonSize = button.sizeThatFits(forFittingSize)

            if UIScreen.main.bounds.size.width - 128 < buttonSize.width {
                item.customView?.snp.makeConstraints { make in
                    make.width.equalTo(UIScreen.main.bounds.size.width - 128)
                }
            }
        }

        return item
    }

}

private extension DomainBarButtonItemFactory {

    func makeButtonConfig(with image: UIImage?, tintColor: UIColor?, title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()

        configuration.image = image
        configuration.baseForegroundColor = tintColor
        configuration.attributedTitle = AttributedString(NSAttributedString(string: title, attributes: attributes))
        configuration.titleLineBreakMode = .byTruncatingTail
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 5

        return configuration
    }

}
