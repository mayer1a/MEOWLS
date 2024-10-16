//
//  AlertAdapter.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import UIKit

struct AlertAction {

    var title: String
    let style: UIAlertAction.Style
    var handler: VoidClosure?

    init(title: String, style: UIAlertAction.Style = .default, handler: VoidClosure? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }

    static var ok: AlertAction {
        .init(title: Strings.Alert.Common.ok, style: .default)
    }

    static var no: AlertAction {
        .init(title: Strings.Alert.Common.no, style: .cancel)
    }

    static var cancel: AlertAction {
        .init(title: Strings.Alert.Common.cancel, style: .cancel)
    }

}

extension AlertViewController {

    func add(_ actions: [AlertAction]) {
        let convertedActions = actions.map({ AlertViewController.Action.init(with: $0) })
        self.add(convertedActions)
    }

}

extension AlertViewController.Action {

    convenience init(with alertAction: AlertAction) {
        let style = Style.init(with: alertAction.style)
        self.init(title: alertAction.title, style: style, handler: alertAction.handler)
    }

}

extension AlertViewController.Action.Style {

    init(with style: UIAlertAction.Style) {
        switch style {
        case .default, .destructive: self = .default
        case .cancel: self = .cancel
        @unknown default: self = .default
        }
    }

}
