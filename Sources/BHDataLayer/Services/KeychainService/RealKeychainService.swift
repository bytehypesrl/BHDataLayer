//
//  RealKeychainService.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine
import Foundation
import KeychainAccess

public struct RealKeychainService: KeychainService {

    // MARK: - Properties

    let keychain: Keychain = Keychain(service: "plannetNetworkingKeychain")

    // MARK: - Public

    public func getPublisher<T: Codable>(key: String) -> AnyPublisher<T?, Error> {
        Future { promise in
            do {
                guard let value = try keychain.getData(key) else {
                    promise(.success(nil))
                    return
                }
                let decoded = try JSONDecoder().decode(T.self, from: value)
                promise(.success(decoded))
            } catch {
                promise(.failure(StorageError.readError(reason: error.localizedDescription)))
            }
        }
        .eraseToAnyPublisher()
    }

    public func get<T: Codable>(key: String) -> T? {
        do {
            guard let value = try keychain.getData(key) else { return nil }
            let decoded = try JSONDecoder().decode(T.self, from: value)
            return decoded
        } catch {
            return nil
        }
    }

    public func set<T: Codable>(_ data: T, forKey key: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                let value = try JSONEncoder().encode(data)
                try keychain.set(value, key: key)
                promise(.success(Void()))
            } catch {
                promise(.failure(StorageError.createError(reason: error.localizedDescription)))
            }
        }
        .eraseToAnyPublisher()
    }

    public func remove(key: String) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try keychain.remove(key)
                promise(.success(Void()))
            } catch {
                promise(.failure(StorageError.resourceNotFound(reason: error.localizedDescription)))
            }
        }
        .eraseToAnyPublisher()
    }
}
