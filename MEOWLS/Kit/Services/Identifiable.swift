//
//  Identifiable.swift
//  MEOWLS
//
//  Created by Artem Mayer on 04.10.2024.
//

import Foundation

/// Протокол доступа к идентификатору товара
public protocol Identifiable {

    var identifier: String { get }

}

extension String: Identifiable {

    public var identifier: String { return self }

}
