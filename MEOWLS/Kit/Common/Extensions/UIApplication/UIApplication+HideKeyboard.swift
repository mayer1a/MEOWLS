//
//  UIApplication+HideKeyboard.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import UIKit

extension UIApplication {

    @objc func hideKeyboard() {
        self.sendAction(#selector(UIResponder().resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
