//
//  UITextField+TextPublisher.swift
//  MEOWLS
//
//  Created by Artem Mayer on 21.10.2024.
//

import UIKit
import Combine

public extension UITextField {

    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }

}
