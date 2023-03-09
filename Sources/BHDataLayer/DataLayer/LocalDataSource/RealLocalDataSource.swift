//
//  RealLocalDataSource.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Resolver
import Combine
import Foundation

public struct RealLocalDataSource {

    // MARK: - Dependencies

    @Injected private var localDataSourceKeyGetter: LocalDataSourceKeyGetter

    @Injected private var localStorageService: LocalStorageService
}

// MARK: - LocalDataSource

extension RealLocalDataSource: LocalDataSource {

    public func save<Element>(dataModel: Element) -> AnyPublisher<Element, Error> where Element: Codable & Saveable {
        localStorageService.save(
            dataModel,
            key: localDataSourceKeyGetter.key(type: String(describing: Element.self), saveableType: Element.saveable),
            validity: Element.validity
        )
        return Just(dataModel)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func get<Element>() -> AnyPublisher<Element, Error> where Element: Codable & Saveable {
        Just(
            localStorageService.get(
                Element.self,
                key: localDataSourceKeyGetter.key(type: String(describing: Element.self), saveableType: Element.saveable)
            )
        )
        .compactMap { $0 }
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    public func isDataValid<Element>(for type: Element.Type) -> Bool where Element: Saveable, Element: Codable {
        localStorageService.isDataValid(
            key: localDataSourceKeyGetter.key(
                type: String(describing: Element.self),
                saveableType: Element.saveable
            )
        )
    }
}
