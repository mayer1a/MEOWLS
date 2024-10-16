//
//  Section.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import Foundation

extension ItemsDataSource {

    public struct Section<U: Item> {

        public let id: String?
        public let header: Any?
        public var items: [U]
        public let footer: Any?

        public init(id: String? = nil, header: Any? = nil, items: [U] = [], footer: Any? = nil) {
            self.id = id
            self.header = header
            self.items = items
            self.footer = footer
        }

        public subscript(index: Int) -> U {
            get {
                items[index]
            }
            set {
                items[index] = newValue
            }
        }

        public mutating func append(_ item: U) {
            items.append(item)
        }

    }

}
