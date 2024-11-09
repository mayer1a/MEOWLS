//
//  NiblessControl.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.09.2024.
//

import UIKit

public class NiblessControl: UIControl {

    public init() {
        super.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable, message: "Loading this control from a nib is unsupported")
    public required init?(coder: NSCoder) {
        fatalError("Loading this control from a nib is unsupported")
    }

}
