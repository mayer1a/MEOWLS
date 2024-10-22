//
//  NiblessCollectionReusableView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 17.10.2024.
//

import UIKit

public class NiblessCollectionReusableView: UICollectionReusableView {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    @available(*, unavailable, message: "Loading this table view cell from a nib is unsupported")
    public required init?(coder: NSCoder) {
        fatalError("Loading this table view cell from a nib is unsupported")
    }

    public func setup() {
        backgroundColor = UIColor(resource: .backgroundWhite)
    }

}
