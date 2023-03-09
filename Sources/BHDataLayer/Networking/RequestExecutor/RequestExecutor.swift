//
//  RequestExecutor.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine
import Foundation
import Alamofire

public protocol RequestExecutor {

    func request<Value>(_ endpoint: ApiEndpoint, errorMapper: ErrorMapper?) -> AnyPublisher<Value, Error> where Value: Decodable

    func requestMock<Value>(_ endpoint: ApiEndpoint, delay: Double, response: Value) -> AnyPublisher<Value, Error> where Value: Decodable

    func uploadCall<Value>(endpoint: ApiEndpoint, fileURL: URL, withName: String) -> AnyPublisher<Value, Error> where Value: Decodable

    func downloadCall<Value>(endpoint: ApiEndpoint) -> AnyPublisher<Value, Error> where Value: Decodable
}

public extension RequestExecutor {
    func request<Value>(endpoint: ApiEndpoint) -> AnyPublisher<Value, Error> where Value: Decodable {
        request(endpoint, errorMapper: nil)
    }
}
