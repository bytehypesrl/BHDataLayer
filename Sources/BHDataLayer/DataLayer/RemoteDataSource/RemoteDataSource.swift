//
//  RemoteDataSource.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine

public protocol RemoteDataSource {

    func fetch<Element: Codable & Equatable>(
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error>

    func fetchById<Element: Codable & Equatable>(
        identifier: String,
        with parameters: [String: Encodable]
    ) -> AnyPublisher<Element, Error>

    func post(with parameters: [String: Encodable]) -> AnyPublisher<Any, Error>

    func patch(with parameters: [String: Encodable]) -> AnyPublisher<Any, Error>

    func delete(with parameters: [String: Encodable]) -> AnyPublisher<Any, Error>
}

extension RemoteDataSource {

    public func fetch<Element: Codable & Equatable>() -> AnyPublisher<Element, Error> {
        fetch(with: [:])
    }

    public func fetchById<Element: Codable & Equatable>(identifier: String) -> AnyPublisher<Element, Error> {
        fetchById(identifier: identifier, with: [:])
    }

    public func post(with parameters: [String: Encodable]) -> AnyPublisher<Any, Error> {
        Fail(error: GeneralError.notImplemented).eraseToAnyPublisher()
    }

    public func patch(with parameters: [String: Encodable]) -> AnyPublisher<Any, Error> {
        Fail(error: GeneralError.notImplemented).eraseToAnyPublisher()
    }

    public func delete(with parameters: [String: Encodable]) -> AnyPublisher<Any, Error> {
        Fail(error: GeneralError.notImplemented).eraseToAnyPublisher()
    }
}
