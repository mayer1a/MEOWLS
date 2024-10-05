//
//  UIApplication+KeyWindow.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import UIKit

extension UIApplication {

    var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter{ $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }

}
