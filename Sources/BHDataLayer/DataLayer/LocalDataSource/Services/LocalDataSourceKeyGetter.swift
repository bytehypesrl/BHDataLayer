//
//  LocalDataSourceKeyGetter.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

public protocol LocalDataSourceKeyGetter {

    func key(type: String, saveableType: SaveableType) -> String
}
