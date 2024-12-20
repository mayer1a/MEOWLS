//
//  NavigationButton.swift
//  MEOWLS
//
//  Created by Artem Mayer on 28.09.2024.
//

import UIKit

public extension UINavigationController {

    enum LeadingButtonType {
        case leftArrow(target: Any? = nil, Selector? = nil)
        case close(target: Any? = nil, Selector? = nil)
        case closeCircle(target: Any? = nil, Selector? = nil)
    }

    enum RightButtonType {
        case location(target: Any?, Selector?)
        case search(target: Any?, Selector?)
    }

    func applyItems(back: LeadingButtonType? = nil, left: LeadingButtonType..., right: RightButtonType...) {
        if let back {
            setupBackButton(back)
        }
        if !left.isEmpty {
            setupLeftButtons(left)
        }
        if !right.isEmpty {
            setupRightButtons(right)
        }
    }

    func appendLeftNavigationItems(leftButtons: LeadingButtonType..., toEnd: Bool = true) {
        let newLeftButtons = buildLeftButtons(leftButtons)

        if viewControllers.last?.navigationItem.leftBarButtonItems == nil {
            viewControllers.last?.navigationItem.leftBarButtonItems = []
        }

        if toEnd {
            viewControllers.last?.navigationItem.leftBarButtonItems?.append(contentsOf: newLeftButtons)
        } else {
            viewControllers.last?.navigationItem.leftBarButtonItems?.insert(contentsOf: newLeftButtons, at: 0)
        }
    }

    func appendRightNavigationItems(rightButtons: RightButtonType..., toEnd: Bool = true) {
        let newRightButtons = buildRightButtons(rightButtons)
        if toEnd {
            viewControllers.last?.navigationItem.rightBarButtonItems?.append(contentsOf: newRightButtons)
        } else {
            viewControllers.last?.navigationItem.rightBarButtonItems?.insert(contentsOf: newRightButtons, at: 0)
        }
    }

    private func setupBackButton(_ backButton: LeadingButtonType) {
        let buttonBuilder = DomainBarButtonItemFactory()

        switch backButton {
        case .leftArrow:
            buttonBuilder.setupImage(Images.Navigation.navigationBackLeading.image)

        case .close:
            buttonBuilder.setupImage(Images.Navigation.navigationClose.image)

        case .closeCircle:
            buttonBuilder.setupImage(Images.Navigation.navigationCloseRounded.image)

        }

        viewControllers.last?.navigationItem.backBarButtonItem = buttonBuilder.make()
    }

    private func setupLeftButtons(_ leftButtons: [LeadingButtonType]) {
        viewControllers.last?.navigationItem.leftBarButtonItems = buildLeftButtons(leftButtons)
    }

    private func setupRightButtons(_ rightButtons: [RightButtonType]) {
        viewControllers.last?.navigationItem.rightBarButtonItems = buildRightButtons(rightButtons)
    }

    private func buildLeftButtons(_ leftButtons: [LeadingButtonType]) -> [UIBarButtonItem] {
        leftButtons.map { leftButton in
            let image: UIImage
            let unwrappedTarget: Any
            let action: Selector

            switch leftButton {
            case .leftArrow(let target, let selector):
                unwrappedTarget = target ?? self
                action = selector ?? #selector(actionClose)
                image = Images.Navigation.navigationBack.image

            case .close(let target, let selector):
                unwrappedTarget = target ?? self
                action = selector ?? #selector(actionClose)
                image = Images.Navigation.navigationClose.image

            case .closeCircle(let target, let selector):
                unwrappedTarget = target ?? self
                action = selector ?? #selector(actionClose)
                image = Images.Navigation.navigationCloseRounded.image

            }

            let button = UIBarButtonItem(image: image, style: .plain, target: unwrappedTarget, action: action)
            button.tintColor = Colors.Icon.iconTertiary.color
            return button
        }
    }

    private var barButtonHeight: CGFloat { 44.0 }

    private func buildRightButtons(_ rightButtons: [RightButtonType]) -> [UIBarButtonItem] {
        rightButtons.map { rightButton in
            switch rightButton {
            case .location(let target, let selector):
                let image = Images.Common.locationButton.image
                let button = UIBarButtonItem(image: image, style: .plain, target: target, action: selector)
                button.tintColor = Colors.Accent.accentPrimary.color
                return button

            case .search(let target, let selector):
                let image = Images.Buttons.search.image
                return UIBarButtonItem(image: image, style: .plain, target: target, action: selector)

            }
        }
    }

}

// MARK: - Actions

extension UINavigationController {

    @objc func actionClose() {
        dismissKeyboard()

        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            popViewController(animated: true)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
