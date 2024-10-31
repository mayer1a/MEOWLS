//
//  FavoritesServiceProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import Foundation
import Combine

public protocol Favoritable {

    var starred: Bool? { get }

}

/// Protocol for working with favorites
public protocol FavoritesServiceProtocol: AnyObject {

    typealias FavoriteItem = Identifiable & Favoritable & Codable
    typealias ToogleCompletion = (Bool) -> Void
    typealias ErrorCompletion = (_ error: String?, _ code: Int?) -> Void

    var favoritesTogglePublisher: CurrentValueSubject<([FavoriteItem]?, Bool), Never> { get }
    var ids: [String] { get }

    func isFavorite(item: FavoriteItem) -> Bool
    func toggle(item: FavoriteItem, completion: ToogleCompletion?)
    func merge() async throws

    #if Store

    var amount: Int { get }

    func clear()

    #endif
    
}
