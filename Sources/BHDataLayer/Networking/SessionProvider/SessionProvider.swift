//
//  SessionProvider.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Alamofire

public protocol SessionProvider {

    static var rootQueueName: String { get set }

    static var requestQueueName: String { get set }

    static var serializationQueueName: String { get set }

    func getSimpleSession() -> Session

    func getSessionWithAuthentication() -> Session
}
