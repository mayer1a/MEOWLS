//
//  KeychainManagerProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 16.09.2024.
//

import Foundation

public protocol KeychainManagerProtocol {

    var deviceId: String? { get }
    var phoneNumber: String? { get set }

    func clear()
    func clear(keys: [String])
    func getValue<C: Codable>(forKey key: String) -> C?
    func set<C: Codable>(value newValue: C?, forKey key: String)

}
