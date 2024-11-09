//
//  Logging.swift
//  MEOWLS
//
//  Created by Artem Mayer on 11.09.2024.
//

import Foundation

public func print(_ items: Any...) {
    #if DEBUG
    items.forEach { item in
        Swift.print(item)
    }
    #endif
}

#if !DEBUG
public func NSLog(_ format: String, _ args: CVarArg...) { }
#endif
