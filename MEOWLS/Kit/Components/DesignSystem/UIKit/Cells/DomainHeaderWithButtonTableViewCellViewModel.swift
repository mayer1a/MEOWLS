//
//  DomainHeaderWithButtonTableViewCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import UIKit

public extension DomainHeaderWithButtonCell {

    struct ViewModel {

        public let title: String
        public let edge: UIEdgeInsets?
        public let cellHeight: CGFloat
        public let buttonModel: ButtonModel?

        public init(title: String, edge: UIEdgeInsets? = nil, buttonModel: ButtonModel? = nil, cellHeight: CGFloat) {
            self.title = title
            self.edge = edge
            self.buttonModel = buttonModel
            self.cellHeight = cellHeight
        }

    }

}

public extension DomainHeaderWithButtonCell.ViewModel {

    struct ButtonModel {
        public let title: String
        public let tapHandler: VoidClosure?
    }

}
