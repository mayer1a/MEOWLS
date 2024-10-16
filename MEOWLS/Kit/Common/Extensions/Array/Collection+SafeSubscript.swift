//
//  Collection+SafeSubscript.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

}
