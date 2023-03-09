//
//  KeychainService.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine

public protocol KeychainService {

    func getPublisher<T: Codable>(key: String) -> AnyPublisher<T?, Error>

    func get<T: Codable>(key: String) -> T?

    func set<T: Codable>(_ data: T, forKey key: String) -> AnyPublisher<Void, Error>

    func remove(key: String) -> AnyPublisher<Void, Error>
}
