//
//  RealSessionProvider.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Resolver
import Alamofire
import Foundation

class RealSessionProvider: SessionProvider {

    // MARK: - Dependencies

    @LazyInjected private var tokenHandler: TokenHandler

    // MARK: - Properties

    static var rootQueueName = "com.iosNetworking.alamofire.session.root"

    static var requestQueueName = "com.iosNetworking.alamofire.session.requests"

    static var serializationQueueName = "com.iosNetworking.alamofire.session.serialization"

    private lazy var sessionWithAuthentication: Session = {
        let sessionConfiguration = URLSessionConfiguration.af.default
        sessionConfiguration.httpAdditionalHeaders = ["Accept-Language" : ""]
        sessionConfiguration.allowsExpensiveNetworkAccess = true

        let credential = OAuthCredential(accessToken: tokenHandler.accessToken, refreshToken: tokenHandler.refreshToken)

        let authenticator = OAuthAuthenticator()

        let interceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                    credential: credential)

        return Session(
            configuration: sessionConfiguration,
            delegate: SessionDelegate(),
            rootQueue: DispatchQueue(label: RealSessionProvider.rootQueueName),
            startRequestsImmediately: true,
            requestQueue: DispatchQueue(label: RealSessionProvider.requestQueueName),
            serializationQueue: DispatchQueue(label: RealSessionProvider.serializationQueueName),
            interceptor: interceptor,
            eventMonitors: [AlamofireLogger()]
        )
    }()

    private lazy var sessonwithNoAuthentication: Session = {
        let session = Session(
            configuration: sessionConfiguration(),
            delegate: SessionDelegate(),
            rootQueue: DispatchQueue(label: RealSessionProvider.rootQueueName),
            startRequestsImmediately: true,
            requestQueue: DispatchQueue(label: RealSessionProvider.requestQueueName),
            serializationQueue: DispatchQueue(label: RealSessionProvider.serializationQueueName),
            eventMonitors: [AlamofireLogger()]
        )
        return session
    }()

    // MARK: - Public

    func getSimpleSession() -> Session {
        sessonwithNoAuthentication
    }

    func getSessionWithAuthentication() -> Session {
        sessionWithAuthentication
    }

    // MARK: - Private

    private func sessionConfiguration() -> URLSessionConfiguration {
        let sessionConfiguration = URLSessionConfiguration.af.default
        sessionConfiguration.headers.remove(name: "Accept-Language")
        sessionConfiguration.allowsExpensiveNetworkAccess = true
        sessionConfiguration.timeoutIntervalForRequest = 60
        return sessionConfiguration
    }

}
