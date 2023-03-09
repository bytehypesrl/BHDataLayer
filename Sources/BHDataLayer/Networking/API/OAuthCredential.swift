//
//  OAuthCredential.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Alamofire
import Foundation

public struct OAuthCredential: AuthenticationCredential {

    // MARK: - AuthenticationCredential

    public let accessToken: String?

    public let refreshToken: String?

    public var requiresRefresh: Bool { return false }

    // MARK: - Init

    public init(accessToken: String?, refreshToken: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
