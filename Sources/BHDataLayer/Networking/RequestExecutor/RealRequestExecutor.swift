//
//  RealRequestExecutor.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Combine
import Resolver
import Alamofire
import Foundation

class RealRequestExecutor {

    // MARK: - Dependencies

    @LazyInjected private var sessionProvider: SessionProvider

    @LazyInjected private var errorHandler: ErrorHandler

    @LazyInjected private var errorMapper: ErrorMapper

    // MARK: - Properties

    private var session = Session()

    let fireNotEarlierThan: Double

    // MARK: - Private

    @discardableResult private func setSession(_ required: Bool) -> Session {
        session = required ? sessionProvider.getSessionWithAuthentication() : sessionProvider.getSimpleSession()
        return session
    }

    // MARK: - Init

    public init(fireNotEarlierThan: Double = 0.4) {
        self.fireNotEarlierThan = fireNotEarlierThan
    }
}

// MARK: - RequestExecutor

extension RealRequestExecutor: RequestExecutor {

    public func request<Value>(_ endpoint: ApiEndpoint, errorMapper: ErrorMapper?) -> AnyPublisher<Value, Error> where Value: Decodable {
        setSession(endpoint.isAuthtenticationTokenRequired)
        return session.request(
            endpoint.baseUrl + endpoint.path,
                               method: endpoint.method,
                               parameters: endpoint.parameters,
                               encoding:  endpoint.encoding,
                               headers: endpoint.headers
        )
        .validate()
        .publishDecodable(type: Value.self)
        .flatMap { response -> AnyPublisher<Value, Error> in
            if let error = response.error {
                if AFError.isAuthorizationError(error) {
                    return Fail<Value, Error>(error: GeneralError.authorizationError).eraseToAnyPublisher()
                }
                let errorMapper = errorMapper ?? self.errorMapper
                let mappedError = errorMapper.map(responseError: error, responseData: response.data)
                return Fail<Value, Error>(error: mappedError).eraseToAnyPublisher()
            }
            guard let value = response.value else {
                let error = GeneralError.emptyResponse
                return Fail<Value, Error>(error: error).eraseToAnyPublisher()
            }
            return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        .handleEvents(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error): self?.errorHandler.handleError(error: error)
                default: break
                }
            }
        )
        .fireNotEarlierThan(delay: .seconds(fireNotEarlierThan), on: RunLoop.main)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func requestMock<Value>(_ endpoint: ApiEndpoint,
                                   delay: Double = 1.0, response: Value) -> AnyPublisher<Value, Error> where Value : Decodable {
        Future { promise in
            promise(.success(response))
        }
        .delay(for: .seconds(delay), scheduler: RunLoop.current)
        .eraseToAnyPublisher()
    }

    public func uploadCall<Value>(endpoint: ApiEndpoint, fileURL: URL, withName: String) -> AnyPublisher<Value, Error> where Value: Decodable {
        setSession(endpoint.isAuthtenticationTokenRequired)
        return session.upload(
            multipartFormData: { multiPartFormData in
                multiPartFormData.append(fileURL, withName: withName)
            },
            to: endpoint.baseUrl + endpoint.path,
            method: endpoint.method,
            headers: endpoint.headers
        )
        .publishDecodable(type: Value.self)
        .flatMap { response -> AnyPublisher<Value, Error> in
            if let error = response.error {
                if AFError.isAuthorizationError(error) {
                    return Fail<Value, Error>(error: GeneralError.authorizationError).eraseToAnyPublisher()
                }
                let errorMapper = self.errorMapper
                let mappedError = errorMapper.map(responseError: error, responseData: response.data)
                return Fail<Value, Error>(error: mappedError).eraseToAnyPublisher()
            }
            guard let value = response.value else {
                let error = GeneralError.emptyResponse
                return Fail<Value, Error>(error: error).eraseToAnyPublisher()
            }
            return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func downloadCall<Value>(endpoint: ApiEndpoint) -> AnyPublisher<Value, Error> where Value: Decodable {
        setSession(endpoint.isAuthtenticationTokenRequired)
        return session.download(
            endpoint.baseUrl + endpoint.path,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
        .publishDecodable(type: Value.self)
        .flatMap { response -> AnyPublisher<Value, Error> in
            if let error = response.error {
                if AFError.isAuthorizationError(error) {
                    return Fail<Value, Error>(error: GeneralError.authorizationError).eraseToAnyPublisher()
                }
                let errorMapper = self.errorMapper
                let mappedError = errorMapper.map(responseError: error, responseData: response.resumeData)
                return Fail<Value, Error>(error: mappedError).eraseToAnyPublisher()
            }
            guard let value = response.value else {
                let error = GeneralError.emptyResponse
                return Fail<Value, Error>(error: error).eraseToAnyPublisher()
            }
            return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
