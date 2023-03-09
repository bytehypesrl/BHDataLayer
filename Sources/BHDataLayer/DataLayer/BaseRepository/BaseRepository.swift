//
//  BaseRepository.swift
//
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine
import Resolver
import Foundation

public protocol BaseRepository {

    var remoteDataSource: any RemoteDataSource { get }

    var localDataSource: LocalDataSource { get }

    var kGetByIdIdentifier: String { get }

    func getValid<Element: Codable & Equatable & Saveable>(
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error>

    func get<Element: Codable & Equatable & Saveable>(
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error>

    func stream<Element: Codable & Equatable & Saveable>(
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error>

    func streamForce<Element: Codable & Equatable & Saveable>(
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error>
}

// MARK: - Properties

public extension BaseRepository {

    var localDataSource: LocalDataSource { Resolver.resolve() }

    var kGetByIdIdentifier: String { "kIdentifier" }
}

// MARK: - Methods

extension BaseRepository {

    // GetValid strategy
    ///
    /// It returns valid (non-expired) content. If the cache contain non-expired content
    /// then it will return it. Otherwise it will fetch it
    ///

    public func getValid<Element>(
        with parameters: [String: Encodable] = [:]
    ) -> AnyPublisher<Element, Error> where Element: Codable & Equatable & Saveable {
        if localDataSource.isDataValid(for: Element.self) {
            return localDataSource.get()
        }
        return fetchAndSaveData(with: parameters)
    }

    // GetStrategy
    ///
    /// GetValid variant which will fallback on the expired cached content but followed
    /// by error which caused the fetch to fail
    ///

    public func get<Element>(
        with parameters: [String: Encodable] = [:]
    ) -> AnyPublisher<Element, Error> where Element: Codable & Equatable & Saveable {
        if localDataSource.isDataValid(for: Element.self) {
            return localDataSource.get()
        }
        return fetchAndSaveData(with: parameters)
            .catch { error -> AnyPublisher<Element, Error> in
                Publishers.Merge(
                    self.localDataSource.get(),
                    Fail(error: error).eraseToAnyPublisher()
                )
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    // StreamStrategy
    ///
    /// This strategy will emit the cached value and, in case the cache is expired, then
    /// it will also emit the newly fetched value (but only if it is different)
    ///

    public func stream<Element>(
        with parameters: [String: Encodable] = [:]
    ) -> AnyPublisher<Element, Error> where Element: Codable & Equatable & Saveable {
        Publishers.Merge(
            localDataSource.get(),
            fetchAndSaveIfCacheInvalid(with: parameters)
        )
        .removeDuplicates()
        .eraseToAnyPublisher()
    }

    // StreamForce strategy
    ///
    /// A Stream variant which forces the fetch even if the cache data is not expired yet
    ///

    public func streamForce<Element>(
        with parameters: [String: Encodable] = [:]
    ) -> AnyPublisher<Element, Error> where Element: Codable & Equatable & Saveable {
        Publishers.Merge(
            localDataSource.get(),
            fetchAndSaveData(with: parameters)
        )
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
}

// MARK: - Private

private extension BaseRepository {

    private func fetch<Element>(
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error> where Element: Codable & Equatable & Saveable {
        if let identifier = parameters[kGetByIdIdentifier] as? String {
            return remoteDataSource.fetchById(identifier: identifier, with: parameters)
        }
        return remoteDataSource.fetch(with: parameters)
    }

    private func fetchAndSaveData<Element>(
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error> where Element: Codable & Equatable & Saveable {
        if let identifier = parameters[kGetByIdIdentifier] as? String {
            return remoteDataSource.fetchById(identifier: identifier, with: parameters)
                .flatMap {
                    self.localDataSource.save(dataModel: $0)
                }
                .eraseToAnyPublisher()
        }
        return fetch(with: parameters)
            .flatMap {
                self.localDataSource.save(dataModel: $0)
            }
            .eraseToAnyPublisher()
    }

    private func fetchAndSaveIfCacheInvalid<Element>(
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error> where Element: Codable & Equatable & Saveable {
        if !localDataSource.isDataValid(for: Element.self) {
            return fetchAndSaveData(with: parameters)
        }
        return localDataSource.get()
    }
}
