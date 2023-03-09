//
//  LocalDataSource.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine

public protocol LocalDataSource {

    func get<Element: Codable & Saveable>() -> AnyPublisher<Element, Error>

    func save<Element: Codable & Saveable>(dataModel: Element) -> AnyPublisher<Element, Error>

    func isDataValid<Element: Codable & Saveable>(for type: Element.Type) -> Bool
}
