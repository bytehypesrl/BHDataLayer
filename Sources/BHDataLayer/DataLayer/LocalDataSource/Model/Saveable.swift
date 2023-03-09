//
//  Saveable.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

public protocol Saveable {

    static var saveable: SaveableType { get }

    static var validity: Double { get }
}

