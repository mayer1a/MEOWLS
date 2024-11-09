//
//  NiblessCollectionViewLayout.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import UIKit

public class NiblessCollectionViewLayout: UICollectionViewLayout {

    public override init() {
        super.init()
    }

    @available(*, unavailable, message: "Loading this table view controller from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this table view controller from a nib is unsupported")
    }

}
