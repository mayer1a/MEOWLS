//
//  Closures.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.09.2024.
//

import Foundation

public typealias VoidClosure = () -> Void
public typealias ParameterClosure<T> = (T) -> Void
public typealias ParametersClosure<T, C> = (T, C) -> Void
