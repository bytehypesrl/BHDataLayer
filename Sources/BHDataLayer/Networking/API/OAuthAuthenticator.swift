//
//  OAuthAuthenticator.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Resolver
import Alamofire
import Foundation

class OAuthAuthenticator: Authenticator {

    // MARK: Dependencies

    @LazyInjected private var tokenHandler: TokenHandler
}

// MARK: - Authenticator

extension OAuthAuthenticator {

    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        let accessToken = tokenHandler.accessToken ?? ""
        let header = HTTPHeader(name: tokenHandler.authorizationHeader, value: accessToken)
        urlRequest.headers.add(header)
    }

    func refresh(_ credential: OAuthCredential, for session: Session, completion: @escaping (Result<OAuthCredential, Error>) -> Void) {
        let _ = session
        let token = credential.refreshToken
        tokenHandler.refreshCurrentToken(token: token ?? "", completion: completion)
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        let _ = urlRequest
        let _ = error

        return response.statusCode == tokenHandler.unauthorizedHttpStatusCode
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        let accessToken = tokenHandler.accessToken ?? ""
        return urlRequest.headers[tokenHandler.authorizationHeader] == accessToken
    }
}
