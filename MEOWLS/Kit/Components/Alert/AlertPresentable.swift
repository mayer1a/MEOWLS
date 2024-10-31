//
//  AlertPresentable.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import UIKit

protocol AlertPresentable: UIViewController {

    /// Показывает AlertViewController.
    /// Если actions отсутствуют - добавит ok по дефолту.
    func showAlert(title: String?, message: String?, actions: [AlertAction])

}

extension AlertPresentable {

    /// Показывает AlertViewController.
    /// Если actions отсутствуют - добавит ok по дефолту.
    func showAlert(title: String?, message: String?, actions: AlertAction...) {
        showAlert(title: title, message: message, actions: actions)
    }

}

struct NetworkErrorAlert {

    let title: String?
    let message: String?
    let repeatTitle: String?
    let cancelHandler: VoidClosure?
    let repeatHandler: VoidClosure?

    init(title: String? = nil,
         message: String? = nil,
         repeatTitle: String? = nil,
         repeatHandler: VoidClosure? = nil,
         cancelHandler: VoidClosure? = nil) {

        self.title = title
        self.message = message
        self.repeatTitle = repeatTitle
        self.repeatHandler = repeatHandler
        self.cancelHandler = cancelHandler
    }

}

extension UIViewController: AlertPresentable {

    func show(warning message: String?, handler: VoidClosure? = nil) {
        guard let message else { return }

        var action = AlertAction.ok
        action.handler = handler
        showAlert(title: Strings.Alert.Warning.attention, message: message, actions: action)
    }

    func showAlert(title: String?, message: String?, actions: [AlertAction]) {
        let actions = actions.isEmpty ? [.ok] : actions

        let alertViewController = AlertViewController(title: title, message: message)
        show(alertViewController: alertViewController, with: actions)
    }

    func showRedAlert(title: String?, message: String?, actions: AlertAction...) {
        let messageColor = UIColor(resource: .accentTertiary)
        let alertViewController = AlertViewController(title: title, message: message, messageColor: messageColor)
        show(alertViewController: alertViewController, with: actions)
    }

    private func show(alertViewController: AlertViewController, with actions: [AlertAction]) {
        alertViewController.add(actions)
        present(alertViewController)
    }

    private func present(_ alertViewController: UIViewController) {
        present(alertViewController, animated: true)
    }

}

extension UIViewController {

    func showLogoutAlert(handler: @escaping VoidClosure) {
        let actionLogout = AlertAction(title: Strings.Alert.Common.yes, style: .destructive, handler: handler)

        showAlert(title: Strings.Profile.Logout.logoutAlertTitle,
                  message: Strings.Profile.Logout.logoutAlertMessage,
                  actions: .no, actionLogout)
    }

    func showDeleteAccountAlert(handler: @escaping VoidClosure) {
        let actionLogout = AlertAction(title: Strings.Alert.Common.yes, style: .destructive, handler: handler)

        showAlert(title: Strings.Profile.UserProfile.deleteAccountAlertTitle,
                  message: Strings.Profile.UserProfile.deleteAccountAlertMessage,
                  actions: .cancel, actionLogout)
    }

    func showNetworkError(with model: NetworkErrorAlert) {

        let errorTitle = title ?? Strings.Alert.NetworkError.title
        let errorMessage = Strings.Alert.NetworkError.message
        let repeatTitle = model.repeatTitle ?? Strings.Alert.NetworkError.repeat
        let cancelTitleDefault = Strings.Alert.NetworkError.cancel

        let repeatAction = AlertAction(title: repeatTitle, style: .destructive, handler: model.repeatHandler)
        let cancelAction = AlertAction(title: cancelTitleDefault, style: .cancel, handler: model.cancelHandler)

        showAlert(title: errorTitle, message: model.message ?? errorMessage, actions: [cancelAction, repeatAction])
    }

    func show(deleteAlert message: String,
              destructiveHandler: @escaping VoidClosure,
              cancelHandler: VoidClosure? = nil) {

        let delete = AlertAction(title: Strings.Alert.Delete.destructive,
                                 style: .destructive,
                                 handler: destructiveHandler)
        let cancel = AlertAction(title: Strings.Alert.Delete.cancel, style: .cancel, handler: cancelHandler)
        showAlert(title: Strings.Alert.Warning.attention, message: message, actions: cancel, delete)
    }

    /// Диалог подтверждения правильности выбранного региона
    func show(confirmationOfRegion region: City?, yesHandler: @escaping VoidClosure, noHandler: @escaping VoidClosure = {}) {
        let yes = AlertAction(title: Strings.Region.Request.yes, style: .destructive, handler: yesHandler)
        let no = AlertAction(title: Strings.Region.Request.no, style: .cancel, handler: noHandler)

        showAlert(title: Strings.Region.Request.title,
                  message: String(format: Strings.Region.Request.isCorrect, region?.name ?? "Неопределен"),
                  actions: no, yes)
    }

}
