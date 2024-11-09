//
//  UIViewController+setupPresentationMode.swift
//  MEOWLS
//
//  Created by Artem Mayer on 31.10.2024.
//

import UIKit

public extension UIViewController {

    enum Mode: Equatable {
        case fullScreen
        case pageSheet(closable: Bool = true)
    }

    func setupPresentationMode(with mode: Mode) {
        switch mode {
        case .fullScreen:
            modalPresentationStyle = .fullScreen

        case .pageSheet(let closable):
            modalPresentationStyle = .pageSheet
            isModalInPresentation = !closable

        }

        navigationItem.backButtonDisplayMode = .minimal
        
        if let sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 20.0
            sheetPresentationController.prefersGrabberVisible = mode == .pageSheet(closable: true)
        }
    }

}
