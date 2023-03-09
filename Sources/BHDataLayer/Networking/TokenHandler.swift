//
//  TokenHandler.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

public protocol TokenHandler {

    typealias RefreshTokenCompletion = (Result<OAuthCredential, Error>) -> ()

    var accessToken: String? { get }

    var refreshToken: String? { get }

    var unauthorizedHttpStatusCode: Int { get }

    var authorizationHeader: String { get }

    func refreshCurrentToken(token: String, completion: @escaping RefreshTokenCompletion)

}
