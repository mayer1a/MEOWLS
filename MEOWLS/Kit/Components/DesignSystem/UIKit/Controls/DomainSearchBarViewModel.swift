//
//  SearchBarViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import Combine

public extension DomainSearchBar {

    struct ViewModel {
        public let placeHolder: String?
        public let state: State
    }

}

public extension DomainSearchBar.ViewModel {

    enum State {
        case initial(DefaultState)
        case searching(Searching)
    }

}

public extension DomainSearchBar.ViewModel.State {

    struct DefaultState {
        public let tapHandler: VoidClosure?
    }

    struct Searching {

        public typealias TFSubject = PassthroughSubject<String, Never>

        public let textFieldSubject: PassthroughSubject<String, Never>?
        public let cancelHandler: VoidClosure?
        public let cancelTitle: String

        public init(textFieldSubject: TFSubject? = nil, cancelHandler: VoidClosure? = nil, cancelTitle: String? = nil) {

            self.textFieldSubject = textFieldSubject
            self.cancelHandler = cancelHandler
            self.cancelTitle = cancelTitle ?? Strings.Common.cancel
        }

    }

}
