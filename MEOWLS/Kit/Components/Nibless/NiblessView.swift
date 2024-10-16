//
//  NiblessView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.09.2024.
//

import UIKit

public class NiblessView: UIView {

    public init() {
        super.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable, message: "Loading this view from a nib is unsupported")
    public required init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported")
    }

}
