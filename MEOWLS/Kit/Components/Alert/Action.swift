//
//  Action.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import UIKit

public extension AlertViewController {

    final class Action {

        public var title: String
        public var style: Style
        public var handler: VoidClosure?

        public init(title: String, style: Style = .default, handler: VoidClosure? = nil) {
            self.title = title
            self.style = style
            self.handler = handler
        }

        @objc
        func callHandler() {
            self.handler?()
        }

    }

}

public extension AlertViewController.Action {

    enum Style {
        case `default`
        case cancel

        func color() -> UIColor {
            switch self {
            case .cancel: return UIColor(resource: .textPrimary)
            case .default: return UIColor(resource: .accentPrimary)
            }
        }

        func font() -> UIFont {
            switch self {
            case .cancel: return UIFont.systemFont(ofSize: 16)
            case .default: return UIFont.systemFont(ofSize: 16, weight: .semibold)
            }
        }
    }

}
