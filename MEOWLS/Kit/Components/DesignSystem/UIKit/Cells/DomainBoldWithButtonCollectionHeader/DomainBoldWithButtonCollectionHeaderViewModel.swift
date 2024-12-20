//
//  DomainBoldWithButtonCollectionHeaderViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 17.10.2024.
//

import UIKit

public extension DomainBoldWithButtonCollectionHeader {

    struct ViewModel {

        public let title: String
        public let buttonTitle: AttributedString?
        public let buttonTapHandler: VoidClosure?

        public init(title: String, buttonTitle: AttributedString? = nil, buttonTapHandler: VoidClosure? = nil) {
            self.title = title
            self.buttonTitle = buttonTitle
            self.buttonTapHandler = buttonTapHandler
        }

    }

}
