//
//  UITableViewCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import UIKit

public class NiblessTableViewCell: UITableViewCell {

    public override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    @available(*, unavailable, message: "Loading this table view cell from a nib is unsupported")
    public required init?(coder: NSCoder) {
        fatalError("Loading this table view cell from a nib is unsupported")
    }

    public func setup() {
        backgroundColor = Colors.Background.backgroundWhite.color
    }

}
