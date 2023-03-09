//
//  AFError+.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Alamofire
import Foundation

extension AFError {

    static func isAuthorizationError(_ error: AFError) -> Bool {
        if case AFError.responseValidationFailed(let reason) = error,
           case AFError.ResponseValidationFailureReason.unacceptableStatusCode(let code) = reason, code == 401 {
            return true
        }
        return false
    }
}
