//
//  ApiEndpoint.swift
//  
//
//  Created by Oanea, George on 21.12.2022.
//

import Alamofire
import Foundation

public protocol ApiEndpoint {

    var baseUrl: String { get }

    var path: String { get }

    var method: HTTPMethod { get }

    var headers: HTTPHeaders? { get }

    var parameters: Parameters { get }

    var encoding: Alamofire.ParameterEncoding { get }

    var isAuthtenticationTokenRequired: Bool { get }
}
