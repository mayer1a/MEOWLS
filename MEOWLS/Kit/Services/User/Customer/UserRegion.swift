//
//  UserRegion.swift
//  MEOWLS
//
//  Created by Artem Mayer on 12.09.2024.
//

import Foundation

public protocol UserRegion: AnyObject {

    var currentRegion: City? { get set }

}

extension User: UserRegion {

    public var currentRegion: City? {
        get {
            settingsService[.userRegion]
        }
        set {
            settingsService[.userRegion] = newValue
        }
    }

}
