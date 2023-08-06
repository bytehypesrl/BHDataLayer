//
//  LocalStorageService.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine
import Foundation

let infinityValidity: Double = -1

public protocol LocalStorageService {

    func get<T: Decodable>(_ type: T.Type, key: String) -> T?

    func save<T: Encodable>(_ value: T, key: String, validity numberOfSeconds: Double)

    func isDataValid(key: String) -> Bool

    func remove(key: String)

    func clearStorage()
}

extension LocalStorageService {

    func save<T: Encodable>(_ value: T, key: String) {
        save(value, key: key, validity: infinityValidity)
    }
}
