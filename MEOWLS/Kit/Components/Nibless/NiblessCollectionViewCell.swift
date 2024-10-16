//
//  NiblessCollectionViewCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit

public class NiblessCollectionViewCell: UICollectionViewCell {

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    @available(*, unavailable, message: "Loading this collection view cell from a nib is unsupported")
    public required init?(coder: NSCoder) {
        fatalError("Loading this collection view cell from a nib is unsupported")
    }

    public func setup() {
        backgroundColor = UIColor(resource: .backgroundWhite)
    }

}
