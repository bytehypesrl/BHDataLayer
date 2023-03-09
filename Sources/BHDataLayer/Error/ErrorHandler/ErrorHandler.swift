//
//  ErrorHandler.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine

public protocol ErrorHandler {

    func getCurrentError() -> AnyPublisher<Any, Error>

    func handleError(error: Error)
}
